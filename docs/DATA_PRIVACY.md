# Data Privacy & Compliance Policy — Finora

## 📌 Document Metadata
* **Document Version**: v1.1.0
* **Status**: Approved Compliance Standard
* **Owner**: Compliance Lead & Project Managers
* **Audience**: Legal teams, end-users, third-party reviewers, developers.
* **Review Cycle**: Prior to any public release or changes in remote connection rules.
* **Cross References**:
  - 📄 [Security Policy](SECURITY.md)
  - 📄 [Product Requirements Document](PRD.md)

---

## 🛡️ 1. Privacy Principles

Finora's product lifecycle relies on user trust:
1. **User Owns 100% of Data**: We do not collect, monetize, analyze, or sell user financial logs.
2. **Zero Default Telemetry**: The app does not transmit usage tracking metrics to remote marketing services.
3. **Explicit Opt-in**: Cloud backup, sync, and AI features in V2 are strictly opt-in.

---

## 📴 2. Offline-First Privacy Benefits

Because Version 1 operates with a **Zero-Network Assumption**:
- User data remains completely local. No remote server is contacted, eliminating the threat of cloud data breaches.
- Registration is not required. Users can initialize the app immediately, keeping their identity anonymous.

---

## 🗑️ 3. Data Export & Deletion Rights (GDPR/CCPA Compliance)

- **Complete Data Portability**: Users can export their entire local database to standard CSV or JSON file formats from the settings panel.
- **Nuke Action**: The settings page includes a "Reset All Data" option. Selecting this option wipes all local Hive database boxes and clears the cryptographic encryption keys from the device's system keychain.
