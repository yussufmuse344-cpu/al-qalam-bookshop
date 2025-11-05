Receive Stock Workflow

Overview

- Add stock professionally without editing products manually.
- Record supplier, reference, notes and line items.
- Inventory increments atomically and an audit trail is kept.

What's included

- Database tables: stock_receipts, stock_receipt_items, stock_movements
- RPC: process_stock_receipt(...) to process a receipt transaction
- UI: Inventory → Receive Stock modal (multi-line receive form)

How to enable

1. Apply the migration in supabase/migrations/20251103100000_add_stock_receipts.sql to your Supabase project.

   - If using the Supabase CLI migrations flow, run a migration deploy.
   - Alternatively, open the SQL editor in Supabase and run the file contents.

2. Deploy the app as usual. The Inventory page will show a “Receive Stock” button next to “Add Product”.

How to use

1. Click Receive Stock.
2. Optionally fill Supplier, Reference, Date and Notes.
3. Add one or more items:
   - Select a product
   - Enter Quantity to receive (required)
   - Optionally add cost per unit for your records
4. Submit. Inventory counts are incremented and the receipt is saved.

Data model (summary)

- stock_receipts: header info for each stock intake
- stock_receipt_items: individual product lines with quantities and optional unit cost
- stock_movements: immutable audit trail (reason = 'RECEIPT')

Permissions

- Basic RLS policies allow authenticated users to select/insert in these tables. Adjust as needed to match your roles.

Notes

- Cost per unit is recorded per line but does not change existing product prices. Extend the RPC if you need average-cost updates.
- All updates are atomic via the process_stock_receipt function.
