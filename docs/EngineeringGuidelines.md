# Engineering Guidelines — Finora

## 📌 1. Document Metadata
* **Document Version**: v1.1.0
* **Status**: Approved Baseline Standard
* **Owner**: Engineering Manager & Staff Flutter Engineer
* **Review Cycle**: Semi-annually or prior to major onboarding expansions
* **Audience**: All software engineers, code reviewers, and AI coding assistants contributing to the Finora codebase.

---

## 🧠 2. Engineering Philosophy

The Finora team maintains a shared software development mindset to ensure the codebase remains maintainable for years to come:

* **Readability Over Cleverness**: Code is read much more often than it is written. Avoid clever "one-liners", micro-optimizations that impair comprehension, and non-obvious helper logic. Write clear, descriptive code that another engineer can easily debug.
* **Simplicity Over Unnecessary Abstraction**: Do not introduce generic interfaces or polymorphic layers until there is a concrete, immediate requirement. A simple, straightforward class is always superior to a forest of pass-through interfaces.
* **Consistency Over Personal Preference**: Within our codebase, we adhere strictly to the established styling conventions. Consistency across the project is more valuable than individual code-formatting preferences.
* **Build for Maintainability**: Always write code assuming the next developer reading it will need to modify it under a tight deadline.
* **Code Should Explain Itself**: Use self-documenting naming conventions for classes, variables, and functions. Comments should explain *why* something is done, not *what* the code does.

---

## 📏 3. General Coding Standards

### Why Consistency Matters
A uniform style makes code review faster, eases developer context-switching, and allows automated code indexing tools to perform static analysis accurately.

### Coding Rules
* **File and Folder Naming**: All files and directories must be named using `snake_case` (e.g., `transaction_list_screen.dart`, `presentation/widgets/`).
* **Class Naming**: Class names, Mixins, and Extensions must use `PascalCase` (e.g., `CategoryRepositoryImpl`). Interfaces must represent their role cleanly without standard prefixes like `I` (e.g., use `AuthRepository`, not `IAuthRepository`).
* **Variable and Method Naming**: Variables, function parameters, and class methods must use `camelCase` (e.g., `final activeAccount = GetIt.I<Account>();`, `void calculateNetWorth()`).
* **Constants**: Global or class-level constants should use `lowerCamelCase` (e.g., `defaultPadding`) or `UPPER_SNAKE_CASE` if they map strictly to immutable external configuration definitions.
* **Enums**: Enum type names must be `PascalCase` and enum values must use `camelCase` (e.g., `enum TransactionType { income, expense, transfer }`).
* **Extensions**: Extension definitions must be placed in a dedicated `utils/` or helper folder within `core/` or the specific feature, explicitly named to prevent global scope contamination.

---

## 📁 4. Project Structure Rules

Finora organizes code around a **Feature-First** topology:

* **What Belongs in `core/`**: Non-feature-specific design systems, app routing setups, dependency injection initializers, global persistent storage wrappers, and cross-cutting network state utilities.
* **What Belongs in `features/`**: Self-contained functional domain directories (e.g., `/transactions`, `/budgets`, `/analytics`). Each feature folder is organized into `data/`, `domain/`, and `presentation/` sub-folders.
* **What Should Never Exist**: Unstructured global "utils" files containing mismatched utility methods, mixed architectural layers (e.g., domain entities carrying storage import instructions), or direct dependencies between adjacent features.
* **Feature Ownership**: Each feature folder must remain self-contained. Features must not depend directly on other features. Instead, they must interact via decoupled events, shared core data models, or dependency-injected interfaces.

---

## 🔄 5. MVVM Rules & Layer Responsibilities

```text
  ┌────────────────────────────────────────────────────────┐
  │                        View (UI)                       │
  │     - Only renders state & forwards user events        │
  └──────────────────────────┬─────────────────────────────┘
                             │ calls
                             ▼
  ┌────────────────────────────────────────────────────────┐
  │                    ViewModel (Cubit)                   │
  │     - Holds view state & coordinates business flows    │
  └──────────────────────────┬─────────────────────────────┘
                             │ invokes
                             ▼
  ┌────────────────────────────────────────────────────────┐
  │                       Repository                       │
  │     - Decouples domain layers from storage details     │
  └──────────────────────────┬─────────────────────────────┘
                             │ delegates to
                             ▼
  ┌────────────────────────────────────────────────────────┐
  │                 DataSource / Services                  │
  │     - Direct database (Hive) or network (Firestore)    │
  └────────────────────────────────────────────────────────┘
```

* **UI (View)**: Responsibilities are limited to rendering UI and dispatching user actions to the Cubit. The View must contain zero business logic or state evaluation rules.
* **Cubit (ViewModel)**: Coordinates screen presentation state. It receives events from the UI, executes domain logic, and emits immutable states. It must never reference `BuildContext`, import UI packages, or perform direct I/O.
* **Repository**: Exposes unified data access contracts to the Presentation layer, abstracting where the data originates.
* **DataSource**: Executes low-level database operations (Hive adapters in V1, Firestore payloads in V2) and translates database maps to Data Transfer Objects (DTOs).
* **Services**: Isolated packages performing third-party API or native integration workflows (e.g., camera access, local notification triggers, platform system calls).

---

## 🔌 6. Dependency Injection Rules

* **Why GetIt**: We use GetIt to decouple the instantiation lifecycle of classes from their consumers, facilitating mock overrides in tests.
* **Registration Strategy**: Infrastructure, databases, and core managers are registered as Singletons at app boot. Repositories and DataSources are registered as Lazy Singletons. Cubits and ViewModels are registered as Factories.
* **Constructor Injection**: All classes must request dependencies strictly via their constructors. Never invoke `GetIt.I<T>()` inside the body of a class method.
* **Avoiding Hidden Dependencies**: Hidden dependencies violate testing isolations. For example, a class constructor must explicitly ask for the repository it uses rather than calling a singleton inside its initialization blocks.

---

## ⚡ 7. State Management Rules

* **One Cubit Per Feature**: Keep state management scopes narrow. Avoid creating giant global Cubits that attempt to manage multiple screens at once.
* **UI Should Remain Declarative**: Use `BlocBuilder`, `BlocConsumer`, and `BlocListener` to rebuild UI reactively based on state changes. Do not manually update widget states using imperative controllers inside Views.
* **Business Logic Belongs in Cubit**: All calculations, validation, and data orchestration must happen in the Cubit, never in the widget's build function.
* **Avoid Giant Cubits**: If a Cubit grows past 300 lines of code, split it into smaller sub-components (e.g., separate `TransactionListCubit` and `TransactionFormCubit`).
* **Common Mistakes**: Passing `BuildContext` into a Cubit, storing state in mutable variables within the Cubit, or using `setState` inside widgets alongside Cubit states.

---

## 📦 8. Repository Rules

* **Why Repositories Exist**: Repositories act as domain-facing wrappers that hide the underlying database type (Hive in V1, Firestore in V2) from the presentation layer.
* **No Direct Hive Access from UI**: The UI must never reference a Hive box or a DataSource directly. All queries must flow through the Repository interface.
* **Local & Remote Implementations**: The repository implementation (`RepositoryImpl`) manages the V1 local storage and orchestrates the V2 background synchronization to Firestore.

---

## 🚨 9. Error Handling Standards

* **Consistent Exception Handling**: Low-level exceptions (e.g., Hive errors, network timeouts) must be caught at the DataSource layer and mapped to custom `Failure` objects in the repository.
* **Failure Objects**: Repositories must return `Either<Failure, T>` instead of throwing runtime exceptions. Standard failures include `DatabaseFailure`, `NetworkFailure`, and `ValidationFailure`.
* **User-Friendly Messages**: Failure classes must expose a localized description to display to the user, protecting them from raw system traces.
* **Logging Strategy**: Log failures via an abstract logging service in `core/` before mapping them to user-friendly messages.

---

## 🌐 10. Localization Standards

* **No Hardcoded Strings**: Every string displayed to the user must be defined in `app_en.arb`.
* **Translation Keys**: Keys must use descriptive camelCase reflecting their position and role (e.g., `transactionListEmptyStateTitle`).
* **Formatting**: Use the `intl` package formatting rules for localized currency, date/time, and pluralized values.
* **RTL Support**: All UI layouts must support Right-to-Left (RTL) text directions by avoiding hardcoded left/right alignments (use start/end instead).

---

## 🎨 11. UI & Spacing Standards

* **Material 3 Foundation**: Leverage Material 3 parameters, dynamic color schemes, and standardized state overlays (hover, focus, pressed).
* **Responsive Layouts**: Use relative layouts and constraints. Avoid hardcoded device dimension values.
* **Accessibility**: Every interactive widget must feature a clear semantic label for screen readers. Minimum touch target sizes are 48x48 dp.
* **Reusable Widgets**: Common UI patterns (cards, buttons, inputs) must be defined as shared components in `core/design_system/`.
* **Spacing Philosophy**: Enforce a strict 8pt grid system. Spacing between components must use predefined layout padding tokens (`xs`, `sm`, `md`, `lg`).

---

## ⚡ 12. Performance Standards

* **Minimize Widget Rebuilds**: Keep widget trees small. Extract complex sub-trees into standalone `const` widgets to optimize rebuild cycles.
* **Lazy Loading**: Use lazy-loading list configurations (`ListView.builder`) for scrollable transaction logs to minimize active memory overhead.
* **Avoid Premature Optimization**: Focus on clean architecture first; optimize layout rendering loops only after finding bottlenecks via profiling tools.
* **Performance Profiling**: Regularly profile the application using Flutter DevTools (CPU Profiler and Memory Allocation tabs) to track memory leaks.

---

## 🧪 13. Testing Expectations

* **Unit Tests**: Mandated for all business calculations, currency mappings, and extension helpers.
* **Cubit Tests**: Use `bloc_test` to verify that actions trigger the correct sequence of immutable state emissions.
* **Repository Tests**: Use mock DataSources (via `mocktail`) to test that repository implementations handle errors, map entities, and query databases correctly.
* **Widget & Golden UI Tests**: Required for core shared components inside `core/design_system/` to prevent unexpected visual regressions across OS platforms.

---

## 📖 14. Documentation Standards

* **Public APIs**: All public class declarations, repository methods, and data models must include DartDoc style comments (`///`).
* **ADR Integration**: Major architectural updates or package inclusions must be documented with an Architectural Decision Record in `docs/ADR/`.
* **Maintenance**: Code changes affecting user flows or configuration schemas must update their corresponding PRD and Architecture specifications in the same Pull Request.

---

## 🔀 15. Git & PR Standards

* **Branch Naming**: Branch names must adhere to the format `<type>/<issue-number>-<short-description>` (e.g., `feat/102-budget-progress`).
* **Commit Conventions**: Use Conventional Commits formatting.
* **Pull Request Guidelines**: PRs must target a specific issue, include screenshots for UI modifications, and verify that all unit tests and static analyses pass locally.
* **Code Review Philosophy**: Code reviews focus on verifying architectural layer boundaries, ensuring test coverage, and reviewing edge-case error handling.

---

## 🤖 16. AI Collaboration Rules

* **AI Code is a Proposal**: AI-generated code snippets are recommendations. The developer is fully responsible for verifying its correctness, security, and architectural fit.
* **Zero Code Blind-Merging**: Never copy-paste AI outputs directly into production files without line-by-line review.
* **Architecture Compliance**: Ensure AI output conforms strictly to the Feature-First and MVVM patterns of the Finora project.

---

## 🚫 17. Common Anti-Patterns to Avoid

* **God Classes**: Monolithic files that handle database writes, UI styling, and state logic in a single implementation block.
* **Massive UI Widgets**: Widget build methods extending past 100 lines of code. Split layouts into modular sub-widgets.
* **Business Logic in UI**: Performing currency calculations, input validation, or date conversions inside build methods. These must live in the Cubit.
* **Tight Coupling**: Direct instantiation of repositories or services inside widgets, making dependency replacement impossible in unit tests.
* **Duplicate Calculation Logic**: Calculating balances or category ratios in multiple screens. Centralize calculation rules inside domain models or UseCases.

---

## 📋 18. Engineering Checklist for Pull Requests

Before marking a PR as ready for review, the developer must verify:
- [ ] Code passes analysis checks cleanly with zero warnings (`flutter analyze`).
- [ ] All unit and widget tests pass locally (`flutter test`).
- [ ] New UI code supports both Light and Dark mode options.
- [ ] All user-facing strings are localized in `app_en.arb`.
- [ ] No direct import dependencies violate architectural layers (e.g., no data models in the UI).
- [ ] Public-facing APIs include DartDoc comments.
- [ ] Commit history is structured following Conventional Commits.
- [ ] Target branch matches formatting specifications.
