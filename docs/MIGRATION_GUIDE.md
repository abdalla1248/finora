# V1 (Hive) to V2 (Firestore) Migration Guide — Finora

## 📌 Document Metadata
* **Document Version**: v1.1.0
* **Status**: Approved Migration Strategy
* **Owner**: Database Architect & Technical Lead
* **Audience**: Backend Engineers, Core Developers, Database Architects, QA Leads.
* **Review Cycle**: Prior to the kick-off of the Version 2 implementation phase.
* **Cross References**:
  - 📄 [Architecture Specification](Architecture.md)
  - 📄 [Product Requirements Document](PRD.md)

---

## 🏛️ 1. Zero-Rewrite Philosophy

To transition from the local Hive engine to Firestore without rewriting presentation views:
- **Interface Decoupling**: ViewModels (Cubits) must depend strictly on abstract repository interfaces, not implementations.
- **DataSource Swapping**: We implement a new `FirestoreRemoteDataSource` and register it in the DI layer. The repository coordinates reading/writing locally first and sending sync operations asynchronously.

---

## 🔀 2. Schema Translation Matrix

| Hive Model (V1) | Firestore Collection (V2) | Sync ID Mapping |
| :--- | :--- | :--- |
| `TransactionModel` | `/users/{userId}/transactions/{txnId}` | Map `hiveKey` to `firestoreId` |
| `CategoryModel` | `/users/{userId}/categories/{catId}` | Map local `id` to remote `docId` |
| `AccountModel` | `/users/{userId}/accounts/{accId}` | Map local `id` to remote `docId` |

---

## ⚙️ 3. Execution Steps for V2 Data Migration

```text
[Step 1: Authenticate] ──► User signs up or logs in via Firebase Auth
                                   │
[Step 2: Detect Local] ──► Repository checks local Hive Box for unsynced records
                                   │
[Step 3: Upload Sync]  ──► Package unsynced records in Firestore WriteBatch
                                   │
[Step 4: Update Keys]  ──► Confirm write ──► Update local records with `isSynced = true`
```

### Rollback Recovery Plan
Before executing Step 3, the repository makes a backup copy of the local Hive storage box. If the migration process fails or is interrupted, the app rolls back to this backup snapshot to prevent local data loss.
