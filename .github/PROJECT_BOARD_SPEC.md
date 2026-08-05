# GitHub Projects Board Specification

## 📌 Document Metadata
* **Purpose**: Blueprint for GitHub Projects v2 Kanban configuration, automated columns, custom metadata fields, and workflow management for Finora.
* **Target Audience**: Engineering Leads, Scrum Masters, Maintainers.
* **Update Frequency**: On process or sprint cadence changes.

---

## 📋 Board Columns & Workflow Rules

| Column | Description | Automated Trigger |
| :--- | :--- | :--- |
| **📥 Backlog** | Unprioritized incoming issues and feature requests. | Newly opened issues. |
| **🎯 Ready for Sprint** | Refined issues with defined acceptance criteria & story points. | Manually moved during sprint planning. |
| **🚧 In Progress** | Active task assigned to a developer. | PR linked or issue assigned. |
| **🔍 In Review** | Code complete; PR submitted and pending approvals. | PR opened and linked to issue. |
| **🧪 In QA / Testing** | Merged to `main`; undergoing automated or manual QA. | PR merged to `main`. |
| **✅ Done** | Verified by QA and included in target milestone release. | Closed issue after verification. |

---

## 🏷️ Custom Fields Schema

- **`Version Target`**: `[V1.0-MVP, V1.5-Advanced, V2.0-CloudSync, V2.5-AI-Shared]`
- **`Architectural Layer`**: `[Core, Presentation, Domain, Data, DesignSystem, DevOps]`
- **`Story Points`**: Fibonacci sequence `[1, 2, 3, 5, 8, 13]`
- **`Priority`**: `[P0-Critical, P1-High, P2-Medium, P3-Low]`
