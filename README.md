# SkyGate - Crew Access Portal 🛫

A **Clean Architecture Proof-of-Concept (PoC)** featuring simulated aviation domain business logic and a lightweight Mock Authentication mechanism for role validation. Built with Flutter and Dart, following enterprise-level loose coupling principles.

This project serves as a showcase of architectural discipline, transforming abstract authentication flows into a concrete, domain-driven enterprise solution without relying on external cloud dependencies.

## 🏗️ Architectural Blueprint & Key Features

Driven by the instruction style of Vandad Nahavandipoor, the project isolates the user interface from the authentication source using strict abstraction layers.

### 1. Loose Coupling via Authentication Abstraction
* **`AuthProvider` (Interface):** An abstract contract establishing the core authentication protocol (`logIn`, `createUser`, `logOut`, `sendEmailVerification`). The UI layer interacts *only* with this contract, completely unaware of the underlying database technology.
* **`MockAuthProvider`:** A memory-driven (RAM) simulation engine that mimics real-world backend behavior, including network delays (`Future.delayed`) and domain-specific exception throwing.
* **`AuthService` (Wrapper):** A factory-driven layer acting as the singular gateway for the application, ensuring that swapping the Mock engine with real Firebase production code requires changing exactly **one line of code**.

### 2. Robust Flow Guarding & Advanced UX (Chapter 22 & 23 Patterns)
* **Auth Flow Guard:** A logic barrier embedded inside the `FutureBuilder` orchestration level. Technicians can register, but they are strictly blocked from accessing sensitive flight logs until their corporate email status is verified.
* **Anti-Stuck UX Pattern:** Resolves the classic screen-lock antipattern by introducing a synchronized `Restart` mechanism that safely clears the in-memory user states and recovers the initial authentication route.

### 3. Production-Ready Code Standards
* **Centralized Routing Engine:** Zero hardcoded string routes. Entire navigation tree is cataloged within `lib/constants/routes.dart`.
* **Reusable UI Components:** Modular error handling dialogs completely abstracted out of the view layer into `lib/utilities/`.
* **Zero Print Policy:** Eradicated standard `print()` statements in favor of structured `dart:developer` logging for professional DevTools inspection.

## 🛠️ Tech Stack & Testing Environment
* **Framework:** Flutter (Material 3)
* **Language:** Dart (Strict Null Safety & OOP)
* **Hardware Testbed:** Samsung Galaxy Tab S6 Lite (SM-P620)
* **Mirror
