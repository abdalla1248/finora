# GitHub Labels & Milestones Recommendation

## 📌 Document Metadata
* **Purpose**: Prescribes standardized GitHub repository labels and milestone release targets for Finora.
* **Target Audience**: DevOps, Engineering Leads, Product Managers.

---

## 🏷️ Standardized Labels Schema

### Category: Type
- `type: bug` `#d73a4a` (Something isn't working)
- `type: feature` `#a2eeef` (New feature or request)
- `type: task` `#7057ff` (Technical work or refactoring)
- `type: docs` `#0075ca` (Documentation changes)

### Category: Scope / Layer
- `layer: core` `#1d76db` (Cross-cutting core infrastructure)
- `layer: domain` `#5319e7` (Domain entities, UseCases, Repository interfaces)
- `layer: data` `#006b75` (DataSources, Hive models, DTOs)
- `layer: presentation` `#e99695` (Widgets, Cubits, Material 3 UI)

### Category: Target Release
- `target: v1.0-mvp` `#0e8a16` (Offline-first core launch)
- `target: v1.5-advanced` `#c2e0c6` (Advanced offline capabilities)
- `target: v2.0-cloud` `#fbca04` (Firebase Auth & Firestore sync)
- `target: v2.5-intelligence` `#fef2c0` (AI Insights, OCR, Shared Wallets)

---

## 🏁 Recommended Milestones

1. **`v1.0.0-alpha (Foundation)`**: Repository skeleton, Core storage engine, Design system setup, Router setup.
2. **`v1.0.0-beta (Offline MVP)`**: Transaction logging, local category budgets, Hive persistence, analytics overview.
3. **`v1.0.0 (Production V1)`**: Polished offline release with local backup, security encryption, CSV export.
4. **`v2.0.0 (Cloud Engine)`**: Firebase integration, dual-data source repository bridge, Firestore sync engine.
