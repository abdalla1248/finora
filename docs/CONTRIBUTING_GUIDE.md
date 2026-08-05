# Comprehensive Contributing Guide — Finora

## 📌 Document Metadata
* **Purpose**: Authoritative guide for developers contributing to the Finora codebase, covering setup, branching, testing, PR protocols, and review expectations.
* **Target Audience**: Core Developers, Open Source Contributors, Technical Leads.
* **Maintenance**: Update when contribution tooling or pull request procedures change.

---

## 🚀 1. Developer Workspace Setup

1. Clone the repository: `git clone https://github.com/your-org/finora.git`
2. Install dependencies: `flutter pub get`
3. Generate local adapters & models: `dart run build_runner build --delete-conflicting-outputs`
4. Run analyzer: `flutter analyze`
5. Run test suite: `flutter test`

---

## 🌿 2. Git Branching & Conventional Commits

- Branch from `main`: `git checkout -b feat/101-transaction-filter`
- Commit message rules: Refer to [.github/BRANCHING_STRATEGY.md](../.github/BRANCHING_STRATEGY.md).

---

## 🏛️ 3. Development Workflow & Layer Boundaries

Refer to [docs/EngineeringGuidelines.md](EngineeringGuidelines.md) and [docs/Architecture.md](Architecture.md) to ensure your changes comply with Feature-First and MVVM constraints.

---

## 🧪 4. Testing & Pull Request Review Process

1. Ensure unit tests cover all new UseCases or Cubit states.
2. Submit PR using [.github/PULL_REQUEST_TEMPLATE.md](../.github/PULL_REQUEST_TEMPLATE.md).
3. Obtain approval from at least 1 core maintainer listed in [.github/CODEOWNERS](../.github/CODEOWNERS).
