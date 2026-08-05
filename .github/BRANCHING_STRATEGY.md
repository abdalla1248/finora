# Branching Strategy & Conventional Commits Guide

## 📌 Document Metadata
* **Purpose**: Defines git branching model, branch naming conventions, Conventional Commit formatting, and PR release flow.
* **Target Audience**: All Engineering Team Members.

---

## 🌿 Branch Naming Conventions

All development branches must be created from `main` using the following strict format:

```text
<type>/<issue-number>-<short-description>
```

### Supported Branch Types
- **`feat/`**: New feature development (e.g., `feat/102-add-category-picker`)
- **`fix/`**: Bug fix (e.g., `fix/204-hive-box-migration-error`)
- **`refactor/`**: Code refactoring without behavioral change (e.g., `refactor/301-cubit-state-normalization`)
- **`docs/`**: Documentation additions or fixes (e.g., `docs/015-update-architecture-spec`)
- **`chore/`**: Maintenance, dependency updates, CI scripts (e.g., `chore/089-upgrade-flutter-lints`)

---

## 📝 Conventional Commit Format

Commit messages must follow the [Conventional Commits](https://www.conventionalcommits.org/) specification:

```text
<type>(<scope>): <short summary>

[optional body]

[optional footer(s)]
```

### Allowed Types
- `feat`: A new feature for the user
- `fix`: A bug fix
- `docs`: Documentation changes only
- `style`: Formatting, missing semi-colons, no code change
- `refactor`: Refactoring production code (no bug fix or feature)
- `test`: Adding missing tests or refactoring tests
- `chore`: Updating build tasks, package configurations, etc.

### Examples
- `feat(transactions): add currency converter UseCase`
- `fix(storage): resolve Hive box lock contention on cold launch`
- `docs(prd): update V2 cloud sync feature requirements`
