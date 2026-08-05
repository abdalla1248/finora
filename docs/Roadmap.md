# Project Roadmap & Prioritization Philosophy — Finora

## 📌 Document Metadata
* **Document Version**: v1.1.0
* **Status**: Approved Strategy Baseline
* **Owner**: Product Owner & Technical Leads
* **Audience**: Engineering Team, Product Managers, Stakeholders, Open Source Contributors.
* **Review Cycle**: Monthly at the start of each development sprint.
* **Cross References**:
  - 📄 [Product Requirements Document](PRD.md)
  - 📄 [Architecture Specification](Architecture.md)

---

## 🎯 1. Prioritization Philosophy

Finora's prioritization matrix is driven by three core axioms:
1. **User Privacy and Data Security First**: Local data encryption and local ownership must be fully functional before adding external features.
2. **Offline Completeness**: Core workflows (transaction tracking, budgeting, and local analytics) must operate perfectly in a zero-network environment.
3. **Architectural Readiness**: Version 1 code must lay down the exact interfaces needed for Version 2 features, minimizing downstream refactoring costs.

---

## 📅 2. Development Milestones & Sprint Timelines

```text
  Phase 0: Foundation  ──►  Phase 1: Offline MVP (v1.0)  ──►  Phase 2: Cloud Sync (v2.0)
     - Sprints 0-1             - Sprints 2-4                       - Sprints 5+
```

### 🏃 Sprint 0: Foundation & Core Harness (Duration: 2 Weeks)
* **Goal**: Establish the engineering environment, core design tokens, and persistent layer abstractions.
* **Deliverables**:
  - DI container setup via `GetIt` and modular routers via `GoRouter`.
  - Cryptographically encrypted local storage box setups using Hive and `flutter_secure_storage`.
  - Initial Design System theme integration supporting Light/Dark M3 modes.

### 🏃 Sprint 1: Local Transaction Engine (Duration: 2 Weeks)
* **Goal**: Build the transactional core data models, local datasources, and base state viewmodels.
* **Deliverables**:
  - Encrypted transaction and category Hive adapters.
  - `TransactionRepositoryImpl` exposing local CRUD operations.
  - State viewmodels (`TransactionCubit`) and 80%+ coverage unit test suites.

### 🏃 Sprint 2: Core User Interface & Budgets (Duration: 2 Weeks)
* **Goal**: Assemble primary dashboard screens, forms, and custom local budget allocations.
* **Deliverables**:
  - Dashboard UI with total net worth card and category expense progress lines.
  - Add/Edit transaction modal supporting custom category selection.
  - Local budgeting category thresholds and alert notifications.

---

## 🚀 3. Release Milestones

### Version 1.0 Milestone: Offline-First Production Launch
- **Scope**: Core dashboard, transaction log, category allocations, budget thresholds, data import/export (JSON/CSV), localized interface, local backups, biometric lock option.
- **Verification**: Zero network connectivity validation, cold launch performance profiling (< 1.2s), Golden UI tests validation.

### Version 2.0 Milestone: Cloud Synchronized Ecosystem
- **Scope**: Firebase account authentication, dual local-remote repository bridge, Firestore synchronizer, automatic network reconnect queue resolver.
- **Verification**: Multi-device transaction sync test suites, data sync durability tests under spotty network conditions.

---

## 🔮 4. Product Evolution (V3+)

In the long-term, Finora aims to support advanced read-only open banking integrations, unified investment tracking widgets, local tax estimation modules, and specialized desktop/macOS platforms with Shared Core logic.
