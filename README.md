# Al Kalam Bookshop 📚

**A Comprehensive, Modern Retail Management Platform for Bookstores**

Al Kalam Bookshop is a fully integrated bookshop management system designed with a strong emphasis on performance, scalability, and user experience. The platform combines POS operations, inventory management, financial workflows, and a customer-facing e-commerce portal—delivered through a refined dark, glassmorphic UI and full Android support.

## ✨ Platform Capabilities

### 📊 Core Functional Modules

#### Inventory Management

End-to-end product lifecycle management, including stock tracking, reorder alerts, buying/selling prices, and featured listings.

#### Point of Sale (POS)

A robust, multi-product checkout interface supporting line-item discounts, order-level discounts, and accurate profit calculations.

#### Sales Management

Full sales history with optimized manual refresh to reduce database costs and ensure predictable performance.

#### Returns Management

A complete returns workflow, including inventory restoration, financial reconciliation, and audit-safe negative sales entries.

#### Cyber Services Tracking

Revenue tracking for ancillary cyber café services such as printing, photocopying, scanning, and document editing.

#### Comprehensive Financial Management

- Investment tracking and automated dividend calculations
- Debt management with repayment schedules
- Expense categorization and analysis
- Professionally formatted PDF inventory and financial reports

#### Customer E-Commerce Portal

Modern storefront with product browsing, featured items, shopping cart, and order management.

#### Role-Based Authentication

Secure access controls for Admin and Staff with Supabase Auth.

#### Receipt Printing

Clean, professional receipt output with accurate discount and profit computation.

## 🎨 Design & User Experience

The application features a polished, modern dark glassmorphic interface, optimized for clarity, aesthetic appeal, and productivity.

### Key Design Elements

- Deep dark theme with subtle glassmorphic layers
- Collapsible navigation sidebar optimized for smaller screens
- Smooth transitions between collapsed and expanded states
- Consistent, clean layout with compact spacing for high-density data views
- Color-coded financial and operational categories:
  - Green/Emerald → Investments & Profits
  - Cyan/Blue → Cyber Services
  - Rose/Red → Debts & Alerts
  - Purple/Gold → Branding & Key Actions
- Responsive architecture across mobile, tablet, and desktop
- Translucent surfaces with gradient accents and hover interactions

## 📱 Android Application

- Built using Capacitor for cross-platform performance
- Custom-designed icon (Purple Book with Golden Crescent)
- Adaptive icons generated for all Android densities
- Full light/dark-mode splash screens
- Branded asset system aligned with the core Al Kalam identity

## 🚀 Technology Stack

- **Frontend:** React 18 + TypeScript
- **Styling:** Tailwind CSS
- **Backend:** Supabase (PostgreSQL, Auth, Storage)
- **Build Tooling:** Vite 5
- **Mobile Runtime:** Capacitor 7
- **PDF Generation:** jsPDF + jspdf-autotable
- **Image Processing:** Sharp (via Capacitor Assets)
- **State Management:** React Query v5 with persistent caching
- **Date Utilities:** Custom formatting utilities (dd/mm/yyyy)

### Cost Optimization Techniques

- Infinite caching to reduce Supabase read operations
- Manual data refresh pattern to avoid unnecessary polling
- Query optimization and precise ordering for efficient database load

## 📦 Installation Guide

```bash
git clone https://github.com/yussufmuse344-cpu/al-qalam-bookshop.git
cd al-qalam-bookshop
npm install
```

Create a `.env` file with the following:

```env
VITE_SUPABASE_URL=your_supabase_url
VITE_SUPABASE_ANON_KEY=your_supabase_anon_key
```

Run database setup scripts in order:

1. `SUPABASE_FULL_BOOTSTRAP.sql`
2. `SUPABASE_FINANCIALS.sql`
3. Any relevant `SUPABASE_PATCH_*.sql` files

Start development:

```bash
npm run dev
```

## 🏗️ Project Structure

```
al-qalam-bookshop/
├── src/
│   ├── components/         # Core UI components
│   ├── hooks/              # Custom React Query hooks
│   ├── lib/                # Utilities & configuration
│   ├── types/              # TypeScript definitions
│   └── styles/             # Style utilities
├── public/                 # Icons & public assets
├── android/                # Capacitor Android project
├── generate-icons.js       # Automated icon generator
└── SQL scripts/            # Supabase SQL schemas
```

## 📱 Key Functional Components

### Point of Sale (POS)

- Multi-product support
- Line-item & global discounts
- Accurate profit computations
- Real-time validation
- Automatic inventory adjustments
- Professional receipt printing

### Sales Management

- Chronological display (newest first)
- Manual refresh with loading indicators
- Inventory restoration on deletion
- Cost-aware caching

### Returns Workflow

- Reason-based return entries
- Automatic stock replenishment
- Automatic negative sales for financial accuracy
- Fully reversible operations
- Transparent audit logs

### Inventory Reports

- PDF export with professional layout
- Total value computation
- Consistent column widths
- A–Z alphabetic sorting

### Customer Store

- Clean product displays
- Featured items
- Search-optimized storefront
- Modern cart UI
- Order tracking lifecycle

### Financial Dashboard

- Revenue and profit breakdown
- Expense analytics
- Investment tracking
- Debt and repayment management

🎨 Design Identity

Name: Al Kalam (Arabic القلم – “The Pen”)

Symbol: Purple book with golden crescent

Themes: Knowledge, Islamic heritage, elegance

Color Palette: Dark gradients with purple and gold highlights

📱 Android Development Workflow

Icon generation:

npm run assets:generate

Sync project:

npm run android:sync

Open in Android Studio:

npm run android:open

Build APK:

npm run android:build

## 🚀 Deployment

### Vercel Deployment (Recommended)

1. Push to GitHub
2. Import into Vercel
3. Set environment variables
4. Deploy with a single click

Build manually:

```bash
npm run build
```

## 🔐 Security Architecture

- Supabase RLS on all tables
- Role-based permissions
- Protected admin routes
- Secure environment variables
- Comprehensive privacy policy

## 📈 Recent Enhancements (Nov 2024)

- Full branding redesign (icon, manifest, configs)
- Sales caching optimization
- Improved PDF formatting
- Complete returns module
- UI refinements for better UX
- Fixed receipt discount calculations

## 🎯 Performance Engineering

- Infinite caching for predictable costs
- Manual data refresh mechanism
- Lazy image loading
- Bundle optimization
- Code splitting via Vite
- Fast HMR during development

## 📱 Supported Platforms

- Chrome, Firefox, Safari, Edge
- Android 7.0+ via Capacitor
- (iOS planned)

## 🔮 Future Roadmap

- [ ] iOS application
- [ ] Barcode scanning
- [ ] Low-stock email alerts
- [ ] Somali / English / Arabic localization
- [ ] Payment gateway integrations
- [ ] Advanced analytics
- [ ] Offline-first PWA mode
- [ ] Customer loyalty program

## 👨‍💻 Developer

**Yussuf Hassan Muse**

- GitHub: [@yussufmuse344-cpu](https://github.com/yussufmuse344-cpu)
- Email: yussufhassan3468@gmail.com

## 📄 License

Proprietary software — All rights reserved by Al Kalam Bookshop.

---

**Al Kalam Bookshop** 📚 - Modern Bookshop Management with Islamic Heritage
