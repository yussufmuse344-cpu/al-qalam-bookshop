/*
  # Stock Receipts and Movements (Simplified)

  This migration adds a professional stock receiving workflow:
  - stock_receipts: header for each receive event (timestamp only)
  - stock_receipt_items: line items for products and quantities received
  - stock_movements: immutable audit trail of stock changes
  - process_stock_receipt(): RPC to insert receipt+items and increment product stock atomically

  Usage (from client):
    rpc('process_stock_receipt', {
      p_items: [
        { product_id: '<uuid>', quantity: 10 },
        { product_id: '<uuid>', quantity: 5 }
      ]
    })
*/

-- Ensure required extension for UUIDs
CREATE EXTENSION IF NOT EXISTS pgcrypto;

-- Stock receipts header (simplified - just timestamp and user)
CREATE TABLE IF NOT EXISTS public.stock_receipts (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  received_by text,
  received_at timestamptz NOT NULL DEFAULT now(),
  created_at timestamptz NOT NULL DEFAULT now(),
  created_by uuid DEFAULT auth.uid()
);

-- Stock receipt line items (simplified - no cost_per_unit)
CREATE TABLE IF NOT EXISTS public.stock_receipt_items (
  id bigserial PRIMARY KEY,
  receipt_id uuid NOT NULL REFERENCES public.stock_receipts(id) ON DELETE CASCADE,
  product_id uuid NOT NULL REFERENCES public.products(id) ON DELETE RESTRICT,
  quantity integer NOT NULL CHECK (quantity > 0)
);

-- Stock movement audit trail
CREATE TABLE IF NOT EXISTS public.stock_movements (
  id bigserial PRIMARY KEY,
  product_id uuid NOT NULL REFERENCES public.products(id) ON DELETE RESTRICT,
  quantity_change integer NOT NULL,
  reason text NOT NULL, -- e.g., 'RECEIPT', 'SALE', 'ADJUSTMENT'
  ref_type text,        -- e.g., 'stock_receipts', 'sales'
  ref_id uuid,
  received_by text,     -- Staff member who performed the action
  created_at timestamptz NOT NULL DEFAULT now(),
  created_by uuid DEFAULT auth.uid()
);

-- Indexes for performance
CREATE INDEX IF NOT EXISTS idx_stock_receipt_items_receipt_id ON public.stock_receipt_items(receipt_id);
CREATE INDEX IF NOT EXISTS idx_stock_receipt_items_product_id ON public.stock_receipt_items(product_id);
CREATE INDEX IF NOT EXISTS idx_stock_movements_product_id ON public.stock_movements(product_id);

-- Enable RLS
ALTER TABLE public.stock_receipts ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.stock_receipt_items ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.stock_movements ENABLE ROW LEVEL SECURITY;

-- Basic policies (adjust as needed for your app auth model)
-- Allow authenticated users to manage receipts and items
CREATE POLICY IF NOT EXISTS "Allow authenticated select receipts" ON public.stock_receipts
  FOR SELECT TO authenticated USING (true);
CREATE POLICY IF NOT EXISTS "Allow authenticated insert receipts" ON public.stock_receipts
  FOR INSERT TO authenticated WITH CHECK (true);

CREATE POLICY IF NOT EXISTS "Allow authenticated select receipt items" ON public.stock_receipt_items
  FOR SELECT TO authenticated USING (true);
CREATE POLICY IF NOT EXISTS "Allow authenticated insert receipt items" ON public.stock_receipt_items
  FOR INSERT TO authenticated WITH CHECK (true);

-- Movements: readable by authenticated; inserts typically via functions
CREATE POLICY IF NOT EXISTS "Allow authenticated select movements" ON public.stock_movements
  FOR SELECT TO authenticated USING (true);
CREATE POLICY IF NOT EXISTS "Allow authenticated insert movements" ON public.stock_movements
  FOR INSERT TO authenticated WITH CHECK (true);

-- RPC to process a stock receipt atomically (simplified parameters)
CREATE OR REPLACE FUNCTION public.process_stock_receipt(
  p_items jsonb
) RETURNS uuid
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
  v_receipt_id uuid := gen_random_uuid();
  v_item jsonb;
  v_product_id uuid;
  v_qty integer;
  v_received_by text;
BEGIN
  IF p_items IS NULL OR jsonb_array_length(p_items) = 0 THEN
    RAISE EXCEPTION 'No items provided';
  END IF;

  -- Get received_by from first item (all items should have same received_by)
  v_received_by := (p_items->0->>'received_by')::text;

  -- Insert receipt header
  INSERT INTO public.stock_receipts(id, received_by, received_at, created_by)
  VALUES (v_receipt_id, v_received_by, now(), auth.uid());

  -- Process each item
  FOR v_item IN SELECT * FROM jsonb_array_elements(p_items) LOOP
    v_product_id := (v_item->>'product_id')::uuid;
    v_qty := COALESCE((v_item->>'quantity')::integer, 0);

    IF v_product_id IS NULL THEN
      RAISE EXCEPTION 'Missing product_id in one of the items';
    END IF;
    IF v_qty <= 0 THEN
      RAISE EXCEPTION 'Invalid quantity for product %', v_product_id;
    END IF;

    -- Insert line item
    INSERT INTO public.stock_receipt_items(receipt_id, product_id, quantity)
    VALUES (v_receipt_id, v_product_id, v_qty);

    -- Increment stock
    UPDATE public.products
      SET quantity_in_stock = quantity_in_stock + v_qty,
          updated_at = now()
      WHERE id = v_product_id;

    -- Audit trail with received_by
    INSERT INTO public.stock_movements(product_id, quantity_change, reason, ref_type, ref_id, received_by, created_by)
    VALUES (v_product_id, v_qty, 'RECEIPT', 'stock_receipts', v_receipt_id, v_received_by, auth.uid());
  END LOOP;

  RETURN v_receipt_id;
END;
$$;

-- Grant execute on function to authenticated users
GRANT EXECUTE ON FUNCTION public.process_stock_receipt(jsonb) TO authenticated;
