# AI Rules of Engagement — Finora

## 📌 Document Metadata
* **Document Version**: v1.2.0
* **Status**: Approved Policy Standard
* **Owner**: Lead Architect & DevOps Lead
* **Audience**: AI Coding Assistants, LLM Subagents, AI-assisted Developers.
* **Review Cycle**: Semi-annually or upon change of core state packages.
* **Cross References**: 
  - 📄 [Architecture Specification](Architecture.md)
  - 📄 [Engineering Guidelines](EngineeringGuidelines.md)
  - 📄 [Design System Specification](DesignSystem.md)

---

## 🤖 1. AI Responsibilities & Scope

As an AI Coding Assistant working on the **Finora** project, your primary responsibility is to act as a strict, senior-level code contributor and architect. You are expected to write code that requires minimal human revision, matches the established architecture exactly, and avoids typical LLM assumptions or shortcuts.

---

## 🚫 2. What AI Must NEVER Do

1. **NEVER Swifly Merge Without Verification**: Never assume an implementation is complete without explaining its side-effects, dependencies, and testing bounds.
2. **NEVER Bypass Architectural Boundaries**: Do not imports UI elements into the Domain layer, nor storage adapters into the Presentation views.
3. **NEVER Introduce Third-Party State Management**: Do not introduce Riverpod, Provider, GetX, or mutable ChangeNotifiers unless documented in an approved ADR. State management is strictly Cubit (`flutter_bloc`).
4. **NEVER Generate Legacy/Verbose Code**: Avoid raw, nested UI trees. Do not create inline styling.
5. **NEVER Ignore Localizations**: Do not write hardcoded string literals (e.g., `text: "Add Transaction"`). All strings must use the localization keys defined in `app_en.arb`.
6. **NEVER Generate Flutter App Code During Planning/Documentation Phases**: If the user requests documentation, blueprints, or ADR planning, do not generate Dart widgets, model schemas, or system configurations.

---

## 🏛️ 3. Architecture & Coding Rules

- **Feature-First Organization**: Create feature-level layers under `lib/src/features/[feature_name]/` containing dedicated `data/`, `domain/`, and `presentation/` folders.
- **Layer Integrity**:
  - `Domain` layer must remain 100% pure Dart, containing entities, repository contracts, and UseCases.
  - `Data` layer contains DTOs, DataSource integrations (Hive adapters, Firestore calls), and Repository implementations.
  - `Presentation` layer holds Widgets, Screens, and Cubits.
- **Dependency Injection**: Use `GetIt` for all services, use cases, and repositories. Register them in feature-level DI modules and retrieve them via constructor parameters.
- **State Management**: Utilize immutable Cubit state flows (`Equatable` or `@freezed`). UI components must be declarative and react strictly to emitted states.

---

## 📏 4. Naming Conventions & Flutter Code Rules

- **Files and Folders**: Must be `snake_case` (e.g., `transaction_card.dart`).
- **Classes**: Must be `PascalCase` (e.g., `TransactionCard`).
- **Variables and Functions**: Must use `camelCase` (e.g., `final activeWalletBalance = 0.0;`).
- **Nullable Values**: Avoid unchecked force unwrap operators (`!`). Use standard null-coalescing (`??`) or conditional chaining.
- **Widget extraction**: Build methods must not exceed 100 lines. Extract modular widgets into `const` classes.

---

## 📝 5. Documentation & Review Expectations

- **DartDoc Comments**: Every public API, UseCase, and Repository contract must contain detailed `///` documentation comments explaining parameters and returns.
- **Reference Integrity**: Relative links inside markdown files must point directly to target files using standard Relative format without backticks.
- **Verify Side-Effects**: AI proposals must analyze memory allocation implications, controller disposal rules, and asynchronous stream cancelations.

---

## 🎯 6. Prompt Writing Recommendations for Developers

To get the highest quality output from AI Assistants in this repository, structure your prompts as follows:
- **Specify Feature Focus**: Direct the AI to a specific feature domain (e.g., `features/transactions`).
- **Enforce Guidelines Check**: Explicitly instruct the AI to cross-reference [docs/EngineeringGuidelines.md](EngineeringGuidelines.md) and [docs/Architecture.md](Architecture.md) before writing code.
- **Request Test Stubs**: Always request corresponding unit/bloc tests along with the generated implementation.

---

## 📋 7. AI Quality Checklist

Before presenting your work, verify that you have satisfied:
- [ ] Code strictly respects the Feature-First directory structure.
- [ ] UI logic is fully decoupled from repositories via Cubits.
- [ ] No raw SQL, Firestore, or Hive calls are placed in presentation views.
- [ ] All public classes and functions carry detailed DartDoc comments.
- [ ] Test coverage stubs are provided for UseCases and Cubits.
- [ ] String literals are localized in `app_en.arb`.
