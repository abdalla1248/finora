# Architecture Specification — Finora

## 📌 1. Document Metadata
* **Document Version**: v1.0.0
* **Status**: Baseline Architecture Specification
* **Owner**: Principal Software Architect
* **Last Updated**: 2026-08-03
* **Review Cycle**: Quarterly or prior to major architectural phase transitions
* **Intended Audience**: Junior Developers, Senior Engineers, Technical Leads, AI Coding Assistants

---

## 🏛️ 2. Architecture Vision

The architectural vision for **Finora** is to build a production-grade personal finance manager that provides zero-latency local operations today while serving as a rock-solid foundation for cloud synchronization, AI intelligence, and multi-user collaboration tomorrow.

### Architectural Philosophy
1. **Offline-First Primary Engine**: Local persistent storage is the ultimate source of truth for the user interface. The application must launch instantly and perform all CRUD operations offline without waiting on network sockets.
2. **Predictable Scalability**: Adding new features (e.g., V2 Cloud Sync, OCR receipt scanning, shared wallets) must be an additive process that builds on top of established interfaces without refactoring core feature modules.
3. **High Testability & Maintainability**: State management, business logic, and data storage are strictly decoupled. Every component can be unit-tested or widget-tested in isolation without mocking the entire app environment.
4. **Strict Separation of Concerns**: UI widgets render state and dispatch events. Cubits hold view state and invoke repository contracts. Repositories coordinate data sources. Data sources communicate with local storage or remote cloud services.
5. **Simplicity Over Unnecessary Complexity**: We choose lightweight, proven abstractions over deep, multi-layered enterprise overkill. Every layer in Finora exists for a clear functional reason.

---

## 💡 3. Why MVVM?

Finora adopts the **Model-View-ViewModel (MVVM)** architectural pattern (implemented via Flutter Widgets as Views and Cubits as ViewModels).

### What is MVVM?
- **Model**: Represents domain entities and business rules (e.g., `Transaction`, `Category`, `Budget`).
- **View**: Renders UI components and listens to state emissions (e.g., Flutter Widgets).
- **ViewModel (Cubit)**: Holds screen state, executes user interactions, delegates to repositories, and emits updated states to the View.

### Why MVVM Was Selected
In Flutter applications, embedding business logic directly inside `StatefulWidget` classes leads to monolithic UI files ("God Widgets") that are impossible to unit test. MVVM isolates UI state management into pure Dart classes (`Cubit`), allowing 100% of UI logic to be unit-tested without launching a device emulator or instantiating widget trees.

### Benefits & Trade-Offs
- **Benefits**:
  - High testability of screen states using `bloc_test`.
  - Clean declarative UI binding using `BlocBuilder` and `BlocListener`.
  - Immutable state transitions eliminate transient race conditions.
- **Trade-Offs**:
  - Requires writing dedicated State classes (`Initial`, `Loading`, `Loaded`, `Error`) for complex screens.
  - Minor boilerplate overhead for trivial static screens.

### Why Not MVC?
In traditional Model-View-Controller (MVC), Controllers often hold reference handles to Views or trigger imperative UI updates. In Flutter's declarative framework, UI is a direct function of State (`UI = f(State)`). MVC fits poorly because it encourages imperative widget manipulation rather than reactive state emission.

### Why Not Full Clean Architecture?
Full Clean Architecture (with separate `UseCase` classes for every simple CRUD operation, redundant DTO-to-Domain mappers, and deep layer boundaries) introduces excessive boilerplate for early-stage products. 

### When Would Full Clean Architecture Become Appropriate?
Clean Architecture layers (such as standalone `UseCase` classes) become appropriate if:
1. Business logic becomes heavily complex (e.g., calculating multi-currency rolling tax brackets).
2. The domain core is shared across non-Flutter Dart clients (e.g., a CLI tool or Dart server backend).
3. The engineering organization scales beyond 10+ concurrent developers working on the same feature module.

For Finora Version 1, MVVM with repository abstraction provides the optimal sweet spot between clean separation and developer velocity.

---

## 📜 4. Architectural Principles

1. **Single Responsibility Principle (SRP)**: Every class, Cubit, or module must have exactly one reason to change. A UI widget only renders UI; a repository only coordinates data; a DataSource only talks to storage.
2. **Dependency Inversion Principle (DIP)**: High-level modules (Cubits, Domain logic) must NOT depend on low-level modules (Hive, Firestore). Both must depend on abstract repository interfaces.
3. **Composition Over Inheritance**: Prefer composing small, focused widgets and utility classes over building deep widget inheritance hierarchies.
4. **Separation of Concerns (SoC)**: Keep presentation logic, business rules, storage logic, and routing isolated in their respective layers.
5. **Feature Isolation**: Features must be self-contained modules. Developing a `transactions` feature should not require modifying code inside an unrelated `analytics` feature.
6. **Explicit Dependencies**: All class dependencies must be explicitly passed through constructors. Hide no dependencies behind global singletons without DI injection contracts.
7. **Offline First**: The local database is always queried first. Network sync operates as a non-blocking background enhancement.
8. **Local Before Remote**: Always save mutations locally first to provide instant UI feedback before attempting background cloud persistence.

---

## 🏗️ 5. High-Level Layer Diagram

```text
┌────────────────────────────────────────────────────────────────────────┐
│                          PRESENTATION LAYER                            │
│                                                                        │
│   ┌───────────────────────────┐         ┌──────────────────────────┐   │
│   │       View / Widget       │◄───────►│  Cubit / State Holder    │   │
│   └───────────────────────────┘         └────────────┬─────────────┘   │
└──────────────────────────────────────────────────────┼─────────────────┘
                                                       │ invokes interface
                                                       ▼
┌────────────────────────────────────────────────────────────────────────┐
│                             DOMAIN LAYER                               │
│                                                                        │
│   ┌───────────────────────────┐         ┌──────────────────────────┐   │
│   │      Domain Entities      │         │   Repository Interface   │   │
│   └───────────────────────────┘         └────────────▲─────────────┘   │
└──────────────────────────────────────────────────────┼─────────────────┘
                                                       │ implements contract
                                                       │
┌──────────────────────────────────────────────────────┴─────────────────┐
│                              DATA LAYER                                │
│                                                                        │
│                   ┌────────────────────────────────┐                   │
│                   │   Repository Implementation    │                   │
│                   └───────────────┬────────────────┘                   │
│                                   │                                    │
│                 ┌─────────────────┴─────────────────┐                  │
│                 ▼                                   ▼                  │
│     ┌──────────────────────┐             ┌──────────────────────┐      │
│     │   Local DataSource   │             │   Remote DataSource  │      │
│     └──────────┬───────────┘             └──────────┬───────────┘      │
└────────────────┼────────────────────────────────────┼──────────────────┘
                 │                                    │
                 ▼                                    ▼
      ┌──────────────────────┐             ┌──────────────────────┐
      │   Hive Box (V1)      │             │   Firestore (V2)     │
      └──────────────────────┘             └──────────────────────┘
```

---

## 📂 6. Feature-First Folder Strategy

Finora organizes source code by **Feature Capabilities** rather than technical roles.

### Why Feature-First?
In role-first structures (`/views`, `/models`, `/controllers`), working on a single feature requires hunting through multiple distant directories. Feature-First co-locates all code related to a single domain capability in one directory, dramatically improving mental context, developer velocity, and feature isolation.

### Root Folder Responsibilities

```
lib/src/
├── app/                         # Global Application Wrapper
│   ├── app.dart                 # Root MaterialApp widget & global providers
│   └── app_bootstrap.dart       # App initialization, async setup & error handling
│
├── core/                        # Shared Infrastructure & Cross-Cutting Concerns
│   ├── design_system/           # Material 3 tokens, typography, shared widgets
│   ├── di/                      # GetIt service locator setup & module binders
│   ├── error/                   # Failure classes & exception mappers
│   ├── network/                 # Internet connection observers (V2 readiness)
│   ├── router/                  # GoRouter configuration & route definitions
│   ├── storage/                 # Hive box encryption, key management & migrations
│   └── utils/                   # Shared extensions, formatters & date helpers
│
└── features/                    # Independent Feature Modules
    ├── transactions/            # Transaction tracking module
    │   ├── data/                # DTOs, Hive Adapters, DataSources, Repository Impl
    │   ├── domain/              # Entities, Repository Interfaces
    │   └── presentation/        # Cubits, States, Screens, Widgets
    ├── budgets/                 # Budgeting & targets module
    ├── analytics/               # Visual charts & financial reporting module
    └── settings/                # Preferences, backup & local security module
```

---

## 🔄 7. Data Flow

### Step-by-Step Data Flow (Version 1 — Offline Execution)

```text
[1. User Interaction] ──► User taps "Save Transaction" in View
                                    │
[2. Call Cubit]       ──► View invokes `transactionCubit.addTransaction(...)`
                                    │
[3. Cubit State]      ──► Cubit emits `TransactionState.loading()`
                                    │
[4. Repository Call]  ──► Cubit awaits `repository.saveTransaction(entity)`
                                    │
[5. Local Persistence]──► Repository passes entity to `LocalDataSource`
                                    │
[6. Hive Write]       ──► `LocalDataSource` writes encrypted record into Hive Box
                                    │
[7. Return Result]    ──► Hive confirms write ──► Repository returns `Right(void)`
                                    │
[8. Emit Success]     ──► Cubit emits `TransactionState.success()`
                                    │
[9. UI Update]        ──► View rebuilds via `BlocBuilder` & shows success feedback
```

### Version 2 Cloud Extension Data Flow

In Version 2, the data flow expands asynchronously without altering Steps 1–9:

```text
[Step 6: Hive Write] ──► Save record locally first & update UI immediately (Offline-First)
                                    │
                                    ├──► [Background Process] Check Network Observer
                                              │
                                              ├─► Connected: Push to `RemoteDataSource` (Firestore)
                                              │              Mark record `isSynced = true`
                                              │
                                              └─► Disconnected: Append to `SyncQueueBox`
                                                                Retry on connection restore
```

---

## 📦 8. Repository Pattern

### Purpose & Definition
The Repository pattern acts as an in-memory collection interface that mediates between the domain layer and the data mapping layers. It presents a clean, unified API for querying and mutating domain entities.

### Key Benefits
- **Hides Storage Details**: The presentation layer never knows whether data comes from Hive, SQLite, or Firestore.
- **Easy Mocking**: Unit testing a Cubit requires mocking only the abstract Repository interface.
- **Dual Data Source Coordination**: In V2, the repository manages the sync choreography between `LocalDataSource` and `RemoteDataSource`.

### Conceptual Isolation Rule
```text
CORRECT:   [UI Widget] ──► [Cubit] ──► [TransactionRepository Interface] ──► [Hive / Firestore]
INCORRECT: [UI Widget] ──► [Hive Box directly] (STRICTLY FORBIDDEN)
```

---

## 🔌 9. Dependency Injection (GetIt)

Finora uses **GetIt** as its Service Locator for dependency injection.

### Why GetIt?
GetIt is lightweight, fast, and does not require a `BuildContext` to resolve dependencies, making service retrieval straightforward outside the widget tree (e.g., inside background tasks or unit tests).

### DI Registration Scopes

1. **Singletons (`registerSingleton`)**: Infrastructure components initialized at launch that live for the app lifecycle (`HiveStorageService`, `AppRouter`, `NetworkObserver`).
2. **Lazy Singletons (`registerLazySingleton`)**: Repositories and DataSources instantiated only when first accessed (`TransactionRepositoryImpl`, `LocalTransactionDataSource`).
3. **Factories (`registerFactory`)**: Cubits and ViewModels created fresh on every screen navigation (`TransactionCubit`, `BudgetAnalyticsCubit`).

---

## 🧭 10. Navigation Strategy (GoRouter)

Finora uses **GoRouter** for declarative navigation.

### Why GoRouter?
GoRouter is the officially recommended declarative routing solution for Flutter. It synchronizes app state with URL paths, making deep linking, web routing, and nested navigation straightforward.

### Architectural Benefits
- **Declarative Routes**: Centralized route manifest defined in `lib/src/core/router/app_router.dart`.
- **Deep Link Ready**: Prepared for Version 2 features like opening a shared wallet via custom scheme URLs (`finora://wallet/join?id=123`).
- **ShellRoute Support**: Supports bottom navigation bar layouts where child screens switch cleanly without rebuilding the global navigation shell.

---

## ⚡ 11. State Management (Cubit)

Finora uses **Cubit** (a lightweight subset of `flutter_bloc`) for state management.

### State Management Framework Comparison

| Framework | Pros | Cons | Decision for Finora |
| :--- | :--- | :--- | :--- |
| **Provider** | Simple to learn, standard context injection. | Encourages mutable `ChangeNotifier` states; easy to mix UI with logic. | ❌ Rejected for lack of state strictness. |
| **Riverpod** | Compile-safe, context-free provider system. | Generator dependency overhead; higher learning curve for junior devs. | ❌ Deferred (Cubit preferred for team familiarity). |
| **Bloc (Event-Driven)** | Explicit event mapping, event transformation. | Verbose; requires event classes for simple form fields and buttons. | ❌ Overkill for standard form & dashboard screens. |
| **Cubit** | **Functions emit state; low boilerplate; 100% immutable; high testability.** | None for standard apps. | ✅ **SELECTED BEST FIT** |

---

## 📴 12. Offline-First Strategy & Sync Conceptuals

### Source of Truth in Version 1
In Version 1, all local data is written to encrypted Hive boxes. The app operates under a **Zero-Network Assumption**.

### Sync Mechanics in Version 2
When Version 2 cloud capabilities are enabled:
1. **Local First**: All user actions write to Hive immediately.
2. **Sync Queue**: Every write creates a corresponding `SyncOperation` entity inside a persistent `SyncQueueBox`.
3. **Background Worker**: A sync worker listens to network state transitions (`NetworkObserver`). When online, it flushes queue operations to Firestore using atomic write batches.

### Conflict Resolution Strategy
- **Strategy**: **Last-Write-Wins (LWW) with Server Timestamp Verification**.
- **Deletions**: Soft-deletions using a `isDeleted` tombstone flag to ensure deleted items are propagated to the cloud correctly before local purge.

---

## 🔮 13. Future Evolution Strategy (V1 to V2 Path)

Finora's architecture is explicitly engineered to prevent breaking changes when introducing V2 features:

1. **Authentication Readiness**: `core/network/` contains authentication state interfaces. Adding Firebase Auth requires providing an `AuthRepositoryImpl` without modifying existing feature cubits.
2. **Dual Data Source Abstraction**: Repositories are designed to hold both `LocalDataSource` and `RemoteDataSource` references from Day 1.
3. **AI & OCR Integration**: Services like camera OCR and AI analytics will be implemented as isolated services in `core/services/` and injected into feature Cubits as optional UseCases.

---

## 📊 14. Architectural Decision Summary

| Architectural Decision | Technical Rationale | Long-Term Evolution Impact |
| :--- | :--- | :--- |
| **MVVM + Cubit** | Provides strict state immutability, low boilerplate, and 100% testable presentation logic. | Easy migration to complex state flows without altering UI widgets. |
| **Hive Local Storage** | Fast, key-value synchronous/asynchronous disk access with AES-256 box encryption. | Serves as the high-speed local cache for Firestore in Version 2. |
| **Repository Pattern** | Decouples domain entities and UI from underlying storage implementations. | Enables seamless swap/addition of Firestore Remote DataSources in V2. |
| **Feature-First Architecture** | High module cohesion; co-locates data, domain, and presentation code per feature. | Allows parallel feature development by separate engineers without git merge conflicts. |
| **GetIt Service Locator** | Fast, context-free dependency injection with clear singleton and factory lifecycles. | Simplifies unit testing via easy interface overrides. |
| **GoRouter Declarative Routing** | Centralized route management with deep linking and nested shell navigation support. | Ready for V2 deep-link notifications (e.g., shared wallet invites). |
| **Material 3 Design System** | Modern financial design aesthetic with dark/light mode tokenization. | Ensures unified UI across future desktop, tablet, and mobile platforms. |
| **Offline-First Strategy** | Guarantees instant cold launches and 100% functionality without internet. | User data remains accessible even during cloud outage or poor connectivity. |

---

## 🧠 15. Engineering Philosophy

To maintain high code quality across the codebase, every engineer and AI assistant must adhere to these core mindset principles:

- **Build for Maintainability**: Code is read 10 times more often than it is written. Write clear, explicit, self-documenting Dart code.
- **Prefer Readability Over Cleverness**: Avoid complex one-liner tricks, obscure extensions, or deep meta-programming.
- **Avoid Premature Optimization**: Do not add unnecessary layers of abstraction until concrete business requirements demand them.
- **Simplicity Beats Unnecessary Abstraction**: A simple, clean Cubit calling a repository is far better than five empty pass-through layers.
- **Every Decision Supports Long-Term Evolution**: Always ask, *"Will this implementation choice make Version 2 cloud synchronization harder or easier?"*
