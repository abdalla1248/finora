# Security Policy & Architecture — Finora

## 📌 Document Metadata
* **Document Version**: v1.1.0
* **Status**: Approved Security Standard
* **Owner**: Technical Lead & DevOps Lead
* **Audience**: Security auditors, core developers, external security researchers.
* **Review Cycle**: Semi-annually or prior to any major remote connection updates.
* **Cross References**:
  - 📄 [Data Privacy Policy](DATA_PRIVACY.md)
  - 📄 [Architecture Specification](Architecture.md)

---

## 🔒 1. Security Philosophy

Finora handles personal financial data. As a result, our security principles are:
- **Zero Plaintext Storage**: Personal financial logs, categories, and account structures must never be stored in plain text on the device.
- **Trustless Client**: In Version 2, the remote server must assume zero validation on the client. All transactions are securely validated via Firestore Security Rules before write acceptance.

---

## 🔑 2. Local Encryption & Key Storage

- **Database Cipher**: Hive boxes containing transactional data use AES-256 box encryption via `HiveAesCipher`.
- **Keychain Keys**: The 256-bit cryptographic encryption key is generated on the first app launch and stored securely in the operating system's native keychain (Keychain on iOS, KeyStore on Android) using the `flutter_secure_storage` package.
- **Biometric authentication**: Passcode or biometric verification is requested to restore the app UI when brought into the foreground.

---

## ☁️ 3. Version 2 Cloud Security (Firestore)

Firestore security rules will enforce:
- **Strict Isolation**: A user can query, write, and delete records only if their authenticated User ID matches the `ownerId` field of the target document.
- **Input Validation**: Check fields for data structure constraints (positive numbers, valid currency ISO codes) prior to database execution.

---

## 🚨 4. Responsible Disclosure Program

If you discover a security vulnerability in this project, do not report it in public issue logs. Please email a description and steps to reproduce directly to `security@finora.app`.
