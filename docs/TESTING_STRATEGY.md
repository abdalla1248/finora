# Testing Strategy & Quality Assurance — Finora

## 📌 Document Metadata
* **Document Version**: v1.1.0
* **Status**: Approved QA Policy
* **Owner**: Technical Lead & QA Lead
* **Audience**: All software engineers, QA specialists, and CI pipelines.
* **Review Cycle**: Quarterly or upon major testing framework upgrades.
* **Cross References**:
  - 📄 [Engineering Guidelines](EngineeringGuidelines.md)
  - 📄 [Architecture Specification](Architecture.md)

---

## 🎯 1. Testing Philosophy

Finora maintains a strict quality gating policy. In financial software, calculation errors can directly impact the user's financial tracking accuracy. Therefore:
- **Zero Raw Logic without Tests**: UseCases, helper extensions, and state viewmodels must be accompanied by comprehensive tests.
- **Coverage Gate**: A minimum of **80% code coverage** is required on all business logic folders before code is approved for production merge.

---

## 📐 2. The Testing Pyramid

```text
       / \        E2E & Integration Tests (10%) - Critical User Journeys
      /   \
     /     \      Widget & Golden UI Tests (30%) - Design System Verification
    /       \
   /─────────\    Unit & Bloc/Cubit Tests (60%) - Business Logic & State Flow
```

---

## 🧪 3. Layer-by-Layer Testing Execution

### Unit & Cubit Tests (60% Weight)
- **Use Cases & Domain logic**: Verify mathematical properties of data transformations, currency conversions, and budgeting limit limits under both normal and edge inputs.
- **State ViewModels (Cubit)**: Test states emitted sequentially in response to user actions using `bloc_test`. Mock dependencies cleanly using constructor parameters.

### Widget & Golden UI Tests (30% Weight)
- **Component Integrity**: Test individual atomic UI elements (e.g., custom currency text fields) to verify proper formatting and input validations.
- **Golden Tests**: Generate baseline visual assets for the custom Design System components in both Light and Dark mode options. Compare visual snapshots in CI to catch regression.

### Integration & E2E Tests (10% Weight)
- **Offline Flow Validation**: Test the complete flow of opening the app, logging a transaction, checking the budget, and exporting JSON backups with zero internet connectivity.
- **V2 Sync Integration**: Validate local modifications are queued and sent correctly to remote data sinks upon mock connection restoration.

---

## 🏷️ 4. Test Naming & Structure Conventions

- **File Path matching**: Test files must mirror the target production file structure inside the `test/` directory.
- **Naming Rule**: Test description should clearly communicate the setup, action, and expected result (e.g., `givenTransactions_whenCalculateBalance_thenReturnSum()`).
