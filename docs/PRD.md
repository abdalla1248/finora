# Product Requirements Document (PRD) — Finora

## 📌 Document Metadata
* **Document Version**: v1.1.0
* **Status**: Under Review
* **Owner**: Lead Product Manager
* **Last Updated**: 2026-08-03
* **Review Cycle**: Monthly prior to sprint planning or upon major milestone changes
* **Purpose**: Authoritative single-source-of-truth for product scope, functional capabilities, target user personas, and versioned feature boundaries (Version 1 vs Version 2).
* **Target Audience**: Product Managers, Engineering Leads, Flutter Developers, QA Engineers, UI/UX Designers.
* **Maintenance**: Update prior to sprint planning or when product scope/milestones are re-prioritized.

---

## 🎯 1. Vision & Strategic Goals

### Vision
To empower individuals and small business owners with a privacy-first, lightning-fast personal finance manager that provides complete local control over financial data while offering seamless cloud synchronization and AI intelligence when needed.

### Goals
- **Instantaneous UX**: Cold app launch in under 1.5 seconds; instant transaction logging (< 100ms UI latency).
- **Privacy-First Core**: 100% functional without an internet connection or user registration in Version 1.
- **Architectural Scalability**: Zero-rewrite transition from local storage (Hive) to cloud ecosystem (Firebase/Firestore) in Version 2.

---

## 💡 2. Product Philosophy

The architecture and design of Finora are guided by these core principles:

- **Offline First**: The local database (Hive) is the primary source of truth. The application must remain fully functional without an internet connection. Network communication is handled as an asynchronous background synchronization process.
- **Privacy First**: Users should not be forced to share their personal or financial data to use the app. All tracking in V1 is kept strictly local on-device.
- **Cloud as an Enhancement**: In V2, cloud features are presented as an opt-in enhancement rather than a prerequisite. The core app remains usable offline even if cloud sync is active.
- **Fast User Experience**: Financial tracking must be friction-free. Transaction logging should require minimal taps, and UI transition latency must be unnoticeable.
- **User Ownership of Data**: The user's data belongs to the user. Finora must always provide clear ways to export data in open formats (CSV/JSON) and completely erase local/remote data.
- **Long-Term Maintainability**: Code structure and local databases are designed from Day 1 to allow for a smooth feature expansion path, avoiding costly refactors when transitioning from V1 to V2.

---

## 📈 3. Success Metrics

To ensure Finora meets its engineering and user experience goals, the following measurable targets must be achieved:

### Version 1 Metrics
* **Cold Start Performance**: App launch time to interactive state under **1.2 seconds** on average mid-tier devices.
* **Transaction Creation Speed**: Saving a transaction locally must take less than **80ms** from tap to screen update.
* **Offline Usability**: 100% of V1 core features (transaction entry, categories, reports, exports) must function with zero network connection.
* **Crash-Free Experience**: Target **99.9%** crash-free sessions.
* **User Experience (UX) Score**: Average task completion time for logging a transaction under **4 seconds**.

### Version 2 Metrics
* **Synchronization Success Rate**: **99.5%** or higher of background synchronization queues resolved without manual user intervention.
* **Conflict Resolution Rate**: Zero data loss during multi-device synchronization conflicts.
* **Auth Latency**: Firebase Authentication sign-in/up completion time under **2 seconds** under normal network conditions.
* **OCR Parse Accuracy**: Over **90%** correct extraction of merchant, date, and currency amounts on clear receipt uploads.

---

## 👥 4. Target Audience & User Personas

### Persona A: Privacy-Conscious Budgeter ("Alex")
- **Needs**: Local data storage, zero cloud tracking, strict expense logging, offline accessibility.
- **Pain Points**: Existing apps force account registration and cloud sync just to track basic daily spending.

### Persona B: Household / Shared Budgeter ("Sam & Morgan")
- **Needs**: Shared wallets, real-time sync across devices, category-level spending limits.
- **Pain Points**: Difficulty keeping track of shared household expenses without manual reconciliation.

### Persona C: Freelancer / Small Business Owner ("Jordan")
- **Needs**: OCR receipt parsing, tax category tags, invoice attachment, business P&L export.
- **Pain Points**: Mixing personal and business expenses, tedious paper receipt management.

---

## 🗺️ 5. Feature Version Matrix

| Feature | Version 1 (Local) | Version 2 (Cloud) | Future (V3+) |
| :--- | :---: | :---: | :---: |
| **Transaction Management** | ✅ (Local) | ✅ (Sync) | ✅ (Sync) |
| **Custom Categories & Budgets**| ✅ (Local) | ✅ (Sync) | ✅ (Sync) |
| **Local Export / Import** | ✅ (CSV/JSON) | ✅ (CSV/JSON) | ✅ (CSV/JSON) |
| **Encrypted Database** | ✅ (Hive AES) | ✅ (Hive AES) | ✅ (Hive AES) |
| **Local Analytics Charts** | ✅ | ✅ | ✅ |
| **Firebase Auth & Sync** | ❌ (Out of Scope)| ✅ | ✅ |
| **Shared Wallets** | ❌ (Out of Scope)| ✅ | ✅ |
| **OCR Receipt Scanner** | ❌ (Out of Scope)| ✅ | ✅ |
| **AI Budgeting Insights** | ❌ (Out of Scope)| ✅ | ✅ |
| **Business Mode** | ❌ (Out of Scope)| ✅ | ✅ |
| **Recurring Transactions** | ❌ (Out of Scope)| ✅ | ✅ |
| **Direct Bank Integrations** | ❌ (Out of Scope)| ❌ (Out of Scope)| ✅ |
| **Investment Tracking** | ❌ (Out of Scope)| ❌ (Out of Scope)| ✅ |

---

## 📴 6. Version 1: Functional Requirements (Offline-First Core)

### 6.1 Transaction Tracking Engine
*TODO:*
- *Define Income, Expense, and Transfer transaction entity fields.*
- *Specify multi-currency entry and local exchange rate converter.*
- *Define transaction search, multi-tag filtering, and date range query rules.*

### 6.2 Category & Budgeting Engine
*TODO:*
- *Define hierarchical category system (Parent category -> Subcategories).*
- *Specify budget allocation types (Monthly, Weekly, One-Time target).*
- *Define budget rollover and warning threshold alerts (e.g., 80% used).*

### 6.3 Analytics & Reporting
*TODO:*
- *Define pie chart breakdown for expense categories.*
- *Specify net worth timeline graph requirements.*
- *Define CSV and JSON local export/import payload structure.*

---

## ☁️ 7. Version 2: Functional Requirements (Cloud Ecosystem & Intelligence)

### 7.1 Firebase Authentication & Cloud Sync Engine
*TODO:*
- *Specify Email/Password, Google, and Apple Sign-In authentication flows.*
- *Define background Firestore synchronization trigger logic and offline conflict resolution.*

### 7.2 Shared Wallets & Multi-User Collaboration
*TODO:*
- *Define wallet permission roles (Owner, Editor, Viewer).*
- *Specify real-time activity log for shared wallet transactions.*

### 7.3 AI Financial Insights & OCR Scanner
*TODO:*
- *Define camera OCR receipt capture, text extraction, and auto-field mapping (Amount, Date, Merchant).*
- *Specify AI model prompt/endpoint specs for monthly anomaly detection and budget optimization tips.*

### 7.4 Recurring Transactions & Business Mode
*TODO:*
- *Define automated recurring scheduler (Daily, Weekly, Monthly, Yearly).*
- *Specify Business Mode toggle, tax deduction tags, and PDF receipt attachment storage.*

---

## ⚡ 8. Non-Functional Requirements

- **Performance**: Frame rate target of 60fps (120fps on supported devices); cold launch < 1.5s.
- **Data Durability**: Zero data loss guarantee during unexpected app termination or device battery death.
- **Accessibility**: WCAG AA contrast ratio compliance, screen reader semantic labels, dynamic font scaling support.
- **Security**: AES-256 local Hive box encryption; zero plaintext storage of financial numbers.

---

## 🚫 9. Out of Scope

The following capabilities are explicitly **Out of Scope** for **Version 1** and deferred to future releases to manage delivery scope and build a stable offline foundation:

- **User Authentication**: No user sign-in, login screens, password resets, or identity providers in V1.
- **Remote Cloud Sync**: No Firestore sync, network synchronization queue managers, or cloud backups.
- **Shared Wallets**: No multi-device collaboration, shared budgets, or real-time wallet sharing.
- **OCR Receipt Scanning**: No image upload, text extraction models, or automatic parsing.
- **AI Insights**: No machine learning suggestions, anomaly alerts, or external LLM integrations.
- **Bank Account Integration**: No Plaid or financial data feed aggregators.
- **Push Notifications**: No local or remote push triggers.
- **Home Screen Widgets**: No Android/iOS widgets.

---

## 🔍 10. Assumptions

The product design and engineering architecture operate under these key assumptions:
* **Single Profile**: V1 users require only a single local finance profile per device installation.
* **Offline Environment**: The user's device may lack internet connectivity for extended periods. All core features must operate natively in this state.
* **Storage Limitations**: App data is capped by device filesystem storage parameters. Data structure overhead must be minimized.
* **Single Device**: In V1, users will not attempt to coordinate data across multiple devices simultaneously.

---

## ⚠️ 11. Risks & Mitigations

| Risk Description | Impact | Probability | Mitigation Strategy |
| :--- | :---: | :---: | :--- |
| **V1 to V2 Schema Conflict**: Migration of local Hive models to remote Firestore schemas leads to data corruption. | High | Medium | Implement explicit version annotations and dual data-source unit tests. Snapshot local data prior to first V2 launch. |
| **Local Storage Growth**: Heavy transaction history or image attachment logs degrade device performance. | Medium | Low | Limit log sizes, optimize local indexing, and restrict local cache size. |
| **Sync Sync Queue Exhaustion**: Background queue sync fails repeatedly due to spotty network. | High | Medium | Use robust retry policies with exponential backoff and persistent transaction queue logging. |
| **Localization Overhead**: Adding multiple currencies/locales slows down UI development. | Low | Low | Adhere strictly to the Dart localization library standards from the initial sprint. |

---

## 📖 12. User Stories & Acceptance Criteria

### User Story 1.1: Log an Expense Offline
- **User Story**: *As a user, I want to quickly log an expense while offline so that my wallet balance stays up to date immediately.*
- **Acceptance Criteria**:
  - [ ] App accepts amount, category, and date without internet connectivity.
  - [ ] Transaction appears on dashboard instantly (< 100ms).
  - [ ] Balance updates locally in Hive box.

*TODO: Add additional user stories for Version 1 and Version 2 features.*

---

## 🔮 13. Product Evolution

Looking beyond Version 2, Finora's long-term product roadmap aims to position it as a comprehensive open financial platform:
- **Direct Bank Aggregators**: Integration with secure open-banking APIs (Plaid, Yodlee, or Open Banking Europe) to pull read-only transaction feeds.
- **Investment & Wealth Portfolios**: Tracking of brokerage accounts, cryptocurrency wallets, and retirement funds in a unified dashboard.
- **Cross-Platform Parity**: Specialized native builds for macOS, Windows, and Web, sharing a common Dart-based core.
- **Community Extensions**: Open APIs or plugin frameworks allowing users to build custom analytics and backup adapters.
- **Automated Tax Filing**: Exporting formatted ledgers directly matching national tax returns (such as IRS Schedule C).
