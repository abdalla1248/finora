# Finora 🏦

**An offline-first personal finance manager built with Flutter, MVVM, Cubit, and Hive.**

---

## 🌟 Overview

Finora is a portfolio-quality personal finance application demonstrating modern Flutter software engineering practices. Built with a **Feature-First Architecture**, **MVVM pattern**, **Encrypted Hive Database**, **Cubit State Management**, and **Material 3 Design**, Finora provides total privacy, smart financial analytics, budget tracking, multi-account support, and local data export capabilities.

---

## ✨ Features (Version 1.0.0)

- 🔒 **100% Offline & Private**: Zero network dependencies, zero trackers, 256-bit AES database encryption.
- 📊 **Smart Financial Analytics**: Visual expense breakdown charts, net cash flow trends, and savings rate ratio computations.
- 🎯 **Budget Management & Savings Goals**: Flexible spending targets with green/yellow/red alert threshold badges and goal progress tracking.
- 💳 **Multi-Account Management**: Track balances across cash wallets, bank accounts, credit cards, and business funds.
- 🏷️ **Custom Categories**: Expense and income category management with customizable color palettes.
- 💾 **Data Export & Local Backup**: Backup your database to JSON or export transactions to spreadsheet-compatible CSV files.
- 🌐 **Internationalization**: Full English and Arabic locale support with native RTL layout handling.

---

## 🛠️ Architecture & Tech Stack

```text
lib/
├── app/                  # Application root & MultiBlocProvider setup
├── bootstrap/            # App bootstrap & error handling initialization
├── core/                 # Shared utilities, DI container, routing, storage, design system
├── features/             # Feature-First modules (MVVM + Cubit + Clean Architecture)
│   ├── account/          # Account management feature
│   ├── analytics/        # Financial analytics & insight charts
│   ├── app_initialization/# App startup & splash screen state
│   ├── backup/           # JSON/CSV export & local backup engine
│   ├── budget/           # Budget targets & savings goals module
│   ├── category/         # Custom category management
│   ├── dashboard/        # Dashboard overview & recent transactions
│   ├── onboarding/       # User profile setup & onboarding flow
│   ├── settings/         # Searchable settings & preferences
│   ├── shell/            # Bottom navigation bar shell
│   ├── transaction/      # Core transaction management engine
│   └── user/             # User profile & locale state
└── l10n/                 # ARB localizations (English & Arabic)
```

- **Framework**: Flutter (Dart 3.x)
- **State Management**: Flutter BLoC / Cubit
- **Dependency Injection**: GetIt
- **Routing**: GoRouter
- **Persistence**: Hive (with `flutter_secure_storage` encryption key management)
- **Functional Error Handling**: `fpdart` (`Either<Failure, T>`)

---

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (v3.19.0 or higher)
- Java Development Kit (JDK 17)

### Installation

1. **Clone the repository**:
   ```bash
   git clone https://github.com/finora/finora.git
   cd finora
   ```

2. **Install dependencies**:
   ```bash
   flutter pub get
   ```

3. **Run code generation**:
   ```bash
   dart run build_runner build --delete-conflicting-outputs
   ```

4. **Generate localizations**:
   ```bash
   flutter gen-l10n
   ```

5. **Run the application**:
   ```bash
   flutter run
   ```

---

## 🧪 Testing

Run static analysis and the full test suite:
```bash
# Static Analysis
flutter analyze

# Unit & Widget Tests
flutter test
```

---

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
