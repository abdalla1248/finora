# Known Limitations & Technical Boundaries (Version 1.0.0)

This document outlines architectural boundaries, intentional trade-offs, and known technical limitations of **Finora Version 1.0.0**.

---

## 🔒 Version 1 Architectural Boundaries

1. **100% Offline-First Architecture**:
   - **No Cloud Synchronization**: Finora V1 stores data exclusively inside encrypted local Hive storage. Multi-device sync is planned for Version 2.0 via Firebase / Cloud Sync.
   - **No Remote User Accounts**: User profile initialization is purely local.

2. **Data Export & Import Scope**:
   - **JSON / CSV Local Export**: File export saves formatted data strings locally. File picker direct OS storage writes will be expanded with native file-picker bindings in future releases.
   - **Single-User Scope**: Finora V1 is designed for single-user offline financial management. Shared wallets and multi-tenant profiles are deferred to Version 2.

3. **Analytics & Calculations**:
   - Analytics computations run locally on in-memory collections. While highly optimized for high transaction throughput, multi-year history aggregations will utilize background Dart isolates in future versions.
