# Technical Specification: Step-2 — Unified Monorepo & Framework-Specific Folder Architecture

## 1. Document Control & Objective

| Property | Value |
|---|---|
| **Specification ID** | `SPEC-STEP-02` |
| **Title** | Unified Monorepo Topology & Framework Architecture Specification |
| **System** | SquareHealth-VMS (Vehicle Management System) |
| **Target Phase** | Phase 2 (Scaffolding & Structural Integrity) |
| **Status** | Approved & Implemented |

### Purpose
This specification formalizes the directory topology, architectural layering, and cross-boundary dependency rules for the SquareHealth-VMS monorepo, incorporating official Flutter Web and Java Spring Boot engineering standards.

---

## 2. Framework-Specific Official Architecture Analysis

### 2.1 Frontend Architecture Standard: Flutter Feature-First
As documented by the official Flutter architectural guidelines, enterprise applications with multiple domains must adopt **Feature-First Architecture**:
* **Modularity**: Domain features (`vehicles`, `dashboard`, `auth`, `maintenance`) are self-contained with their own `presentation/`, `services/`, and `data/` sub-packages.
* **Core Foundation (`core/`)**: Cross-cutting utilities, theme tokens, HTTP clients, and validation logic shared across features.
* **Shared UI Kit (`shared/`)**: Reusable UI components (`AppShell`, `StatusBadge`) that have zero domain coupling.

### 2.2 Backend Architecture Standard: Spring Boot Layered Architecture
In alignment with official Spring Framework conventions, enterprise REST services follow a **Strict Layered Separation of Concerns**:
* **Controller Layer (`controller/`)**: HTTP endpoints, path variable mapping, request body validation (`@Valid`).
* **Service Layer (`service/`)**: Business rule execution, transaction demarcation (`@Transactional`), uniqueness checking.
* **Repository Layer (`repository/`)**: Data persistence and Spring Data JPA queries.
* **Domain Model (`entity/`)**: Relational database entity mappings.
* **Data Transfer Objects (`dto/`)**: Decoupled request/response contracts preventing database entity leakage.
* **Exception Interceptor (`exception/`)**: Global `@RestControllerAdvice` unifying error envelopes.

---

## 3. Unified Monorepo Directory Topology

```
SquareHealth-VMS/
├── 1.Requirement_Gathering/             # Multi-source requirement ingestion pipeline & SRS
│   ├── Document/                        # Source Word specifications
│   ├── UdemyScrapper/                   # Scraped course curriculum (7 sections)
│   ├── YoutubeScrapper/                 # Audio files (.mp3) & session transcripts (.md)
│   ├── Requirement Gathering.png        # Ingestion architecture diagram
│   └── REQUIREMENTS.md                  # Consolidated Single Software Requirements Specification
├── specifications/                      # Centralized technical specification repository
│   ├── README.md                        # Master specification catalog & index
│   ├── specifications/STEP_3_SPECIFICATION.md             # Canonical REST API data contracts & DTO schemas
│   ├── STEP_1_REQUIREMENTS_SPECIFICATION.md
│   ├── STEP_2_FOLDER_STRUCTURE_SPECIFICATION.md
│   └── STEP_3_SPECIFICATION.md
├── vms-frontend/                        # Flutter Web client (Feature-First Architecture)
│   ├── assets/
│   │   └── mock_data/                   # Offline mock data for isolated UI prototyping
│   │       └── vehicles_mock.json
│   ├── lib/
│   │   ├── core/                        # Theme, constants, networking, validators
│   │   ├── features/                    # Auth, Vehicles, Dashboard, Maintenance, Drivers
│   │   ├── shared/                      # Reusable widgets (AppShell, StatusBadge)
│   │   └── main.dart                    # Web app entry point & router orchestrator
│   └── web/                             # Web bootstrap, HTML shell, and manifest
├── vms-backend/                         # Java Spring Boot service (Layered Architecture)
│   ├── src/main/java/com/starkgroup/vms/
│   │   ├── config/                      # CORS & Security configuration
│   │   ├── controller/                  # REST Controllers (/api/v1/vehicles, /api/v1/auth)
│   │   ├── dto/                         # Request & Response DTOs
│   │   ├── entity/                      # Relational JPA entities
│   │   ├── exception/                   # Global exception handling & custom exceptions
│   │   ├── repository/                  # Spring Data JPA repositories
│   │   └── service/                     # Business logic interfaces & implementations
│   └── src/main/resources/              # Application properties & SQL migration scripts
├── scripts/                             # Quality audit, rendering verification, and tooling
│   └── audit_rendering.py               # Universal zero-failure rendering auditor
├── notebook/                            # Kid-friendly educational documentation
│   └── Notebook.md                      # Comprehensive explain-to-a-10-year-old guide
├── chat/                                # Conversation logs & session history
│   └── chat.md                          # Full transcript of user requests & agent actions
├── FOLDER_STRUCTURE.md            # Detailed framework-specific & merged folder documentation
└── Generic_Project_Template/Any Project Skill.docx               # Step-by-step master project blueprint
```

---

## 4. Module Isolation & Architectural Boundary Rules

1. **Strict Client-Server Isolation**: Code inside `vms-frontend/` must never reference or depend on Java packages in `vms-backend/`. All cross-boundary communication occurs exclusively over standard HTTP/JSON via contracts defined in `specifications/STEP_3_SPECIFICATION.md`.
2. **DTO Isolation**: Backend database `@Entity` classes must never be returned directly from REST endpoints. All payloads must be mapped to immutable `DTO` records.
3. **Asset Decoupling**: Static assets, mock datasets, and media files must reside inside designated `assets/` sub-folders, declared within `pubspec.yaml` to ensure cross-platform web loading.
4. **Tooling & Scripts Centralization**: Automated scripts for continuous integration, code auditing, and documentation validation must reside in `scripts/`.

---

## 5. Deliverables & Verification Checklist

- [x] Verified official Flutter Web feature-first directory layout on disk.
- [x] Verified official Spring Boot layered directory layout on disk.
- [x] Documented architectural rationale in [`FOLDER_STRUCTURE.md`](../FOLDER_STRUCTURE.md).
- [x] Synchronized monorepo directory tree in master [`README.md`](../SPECIFICATIONS_CATALOG.md).

