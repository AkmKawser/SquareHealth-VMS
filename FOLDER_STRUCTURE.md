# Full-Stack Vehicle Management System (VMS)
## Project Folder Structure Specification & Architecture Rationale

This document details the project structure for the **SquareHealth-VMS (Stark Group Fleet Management System)** based on official architectural standards from both the **Flutter** (Frontend) and **Spring Boot** (Backend) official documentation, along with the unified/merged enterprise architecture and the engineering rationale behind every component.

---

## 1. Official Frontend Folder Structure (Flutter Web)

### 1.1 Official Architecture Source & Philosophy
According to the official **Flutter Documentation** ([flutter.dev](https://docs.flutter.dev/resources/architectural-overview) & [docs.flutter.dev/app-architecture](https://docs.flutter.dev/app-architecture)), professional Flutter applications follow a **Feature-First Layered Architecture** with distinct separation between:
1. **Presentation Layer**: UI widgets, screens, controllers, and view states.
2. **Domain/Service Layer**: Business rules, state management, and orchestration.
3. **Data Layer**: Repositories, REST API client, DTOs, serialization (`fromJson`/`toJson`), and mock data sources.
4. **Core Layer**: Reusable cross-cutting concerns (theme, constants, networking, utilities).

### 1.2 Individual Flutter Web Layout
```text
vms-frontend/
├── analysis_options.yaml            # Official Flutter & Dart linter rules
├── pubspec.yaml                     # Project metadata, dependencies, assets declaration
├── web/                             # Flutter Web hosting shell
│   ├── favicon.png                  # Browser tab icon
│   ├── index.html                   # HTML entry point and web canvas configuration
│   └── manifest.json                # Web app manifest for PWA/responsive desktop
├── assets/                          # Static assets and local mock payloads
│   ├── images/                      # Branding logos and vehicle icons
│   └── mock_data/                   # Mock JSON files for offline UI/UX verification
├── lib/                             # Root of all Dart application code
│   ├── main.dart                    # Application entry point (runApp, theme initialization)
│   ├── core/                        # Shared cross-cutting modules
│   │   ├── constants/               # API endpoints, route names, asset paths
│   │   │   ├── api_constants.dart
│   │   │   └── app_colors.dart
│   │   ├── network/                 # Centralized HTTP/REST client
│   │   │   └── api_client.dart
│   │   ├── theme/                   # Stark Group Material 3 design system styling
│   │   │   └── app_theme.dart
│   │   └── utils/                   # Validation helpers and formatters
│   │       └── validators.dart
│   ├── features/                    # Feature-First modular components
│   │   ├── auth/                    # Authentication feature module
│   │   │   ├── data/                # Auth models and tokens
│   │   │   ├── presentation/        # Login screen and login form widgets
│   │   │   └── services/            # Auth HTTP service & session state
│   │   ├── vehicles/                # Core Vehicle Fleet Management feature
│   │   │   ├── data/                # VehicleModel (JSON serialization)
│   │   │   ├── presentation/        # VehicleListScreen, VehicleFormScreen
│   │   │   └── services/            # VehicleService (CRUD REST calls)
│   │   ├── documents/               # Advanced Feature: Vehicle Document Management
│   │   │   └── presentation/        # Document upload and compliance views
│   │   ├── maintenance/             # Advanced Feature: Maintenance tracking
│   │   │   └── presentation/        # Service records and expense logs
│   │   ├── drivers/                 # Advanced Feature: Driver management
│   │   │   └── presentation/        # Driver CRUD and assignment views
│   │   └── dashboard/               # Advanced Feature: Executive summary & analytics
│   │       └── presentation/        # Fleet KPI cards and overview charts
│   └── shared/                      # Reusable UI widgets across all features
│       └── widgets/                 # AppShell (Sidebar + AppBar), CustomButton, StatusBadge
└── test/                            # Unit and Widget test suite
    └── widget_test.dart             # Smoke and widget tests
```

### 1.3 Reason Behind Flutter Structure
- **Feature-First Modularity**: Grouping code by feature (`auth`, `vehicles`, `maintenance`) rather than technical type makes code discoverable and maintainable as the project grows from Assignment 1 to Assignment 2.
- **Isolated Data & Network Layer**: Keeping HTTP calls (`api_client.dart`) and models separate from UI widgets ensures UI widgets never directly perform raw HTTP communication or JSON parsing, conforming to course guidelines.
- **Dedicated Web Platform Folder (`web/`)**: Houses web-specific bootstrap files required for Netlify static deployment and web canvas optimization.

---

## 2. Official Backend Folder Structure (Java Spring Boot)

### 2.1 Official Architecture Source & Philosophy
According to the official **Spring Framework & Spring Boot Reference Documentation** ([spring.io/guides](https://spring.io/guides) and [maven.apache.org](https://maven.apache.org/guides/introduction/introduction-to-the-standard-directory-layout.html)), enterprise Spring Boot applications follow the **Maven Standard Directory Layout** and **Classic Layered Architecture (N-Tier)**:
1. **Controller Layer**: Handles HTTP requests, input validation, and REST response codes.
2. **Service Layer**: Owns all business logic, transactions, and business rules (e.g., Duplicate Vehicle validation).
3. **Repository Layer**: Abstraction over database operations using Spring Data JPA.
4. **Entity / Domain Layer**: JPA entities representing relational database tables.
5. **DTO Layer**: Decouples internal database entities from external client JSON payloads.
6. **Exception Layer**: Global centralized exception handling returning standardized error responses.

### 2.2 Individual Spring Boot Layout
```text
vms-backend/
├── pom.xml                          # Maven build configuration, plugins, dependencies
├── src/
│   ├── main/
│   │   ├── java/
│   │   │   └── com/
│   │   │       └── starkgroup/
│   │   │           └── vms/
│   │   │               ├── VmsApplication.java         # Spring Boot main class
│   │   │               ├── config/                     # CORS, Security, JPA configuration
│   │   │               │   ├── CorsConfig.java
│   │   │               │   └── SecurityConfig.java
│   │   │               ├── controller/                 # REST API endpoints
│   │   │               │   ├── AuthController.java
│   │   │               │   └── VehicleController.java
│   │   │               ├── dto/                        # Data Transfer Objects
│   │   │               │   ├── request/
│   │   │               │   │   ├── LoginRequestDto.java
│   │   │               │   │   └── VehicleRequestDto.java
│   │   │               │   └── response/
│   │   │               │       ├── AuthResponseDto.java
│   │   │               │       ├── ErrorResponseDto.java
│   │   │               │       └── VehicleResponseDto.java
│   │   │               ├── entity/                     # JPA Database Entities
│   │   │               │   ├── User.java
│   │   │               │   └── Vehicle.java
│   │   │               ├── exception/                  # Error handling & custom exceptions
│   │   │               │   ├── DuplicateVehicleException.java
│   │   │               │   ├── GlobalExceptionHandler.java
│   │   │               │   └── ResourceNotFoundException.java
│   │   │               ├── repository/                 # Spring Data JPA interfaces
│   │   │               │   ├── UserRepository.java
│   │   │               │   └── VehicleRepository.java
│   │   │               └── service/                    # Business logic interfaces & impl
│   │   │                   ├── AuthService.java
│   │   │                   ├── VehicleService.java
│   │   │                   └── impl/
│   │   │                       ├── AuthServiceImpl.java
│   │   │                       └── VehicleServiceImpl.java
│   │   └── resources/                                  # Static resources & configs
│   │       ├── application.properties                  # Production / default properties
│   │       └── application-dev.properties              # Local dev / H2 / MySQL profile
│   └── test/
│       └── java/
│           └── com/
│               └── starkgroup/
│                   └── vms/
│                       ├── VmsApplicationTests.java    # Context load test
│                       ├── controller/                 # MockMvc REST API integration tests
│                       │   └── VehicleControllerTest.java
│                       └── service/                    # Mockito Unit tests for business rules
│                           └── VehicleServiceTest.java
```

### 2.3 Reason Behind Spring Boot Structure
- **Layered Responsibility**: Controllers never touch SQL directly; Repositories never know about HTTP; Services strictly enforce business rules like uniqueness.
- **DTO Isolation**: JPA entities (`Vehicle.java`) are never exposed directly to REST clients, preventing security vulnerabilities and accidental circular serialization.
- **Dedicated Test Hierarchy**: Mirrors the package structure under `src/test/java` allowing Mockito unit tests (testing duplicate vehicle rules without a DB) and MockMvc integration tests to run cleanly in CI/CD.

---

## 3. Merged Unified Project Folder Structure

### 3.1 Merged Workspace Architecture
The full-stack application adopts a **Clean Monorepo Layout** that unifies the requirements pipeline, the Flutter Web client, and the Spring Boot backend service while maintaining complete technical isolation between the stacks:

```text
SquareHealth-VMS/
│
├── 1.Requirement_Gathering/                             # Requirement Engineering Artifacts
│   ├── Document/
│   │   └── Projecet Requirements DataV.docx             # Original Word requirement document
│   ├── UdemyScrapper/                                   # 7 Course curriculum modules & guides
│   │   ├── 01_The Story & Build Roadmap/
│   │   ├── 02_Build the Flutter Web Frontend/
│   │   ├── 03_Build the Spring Boot Backend & Database/
│   │   ├── 04_Connect Flutter Web to the Backend/
│   │   ├── 05_Testing the VMS/
│   │   ├── 06_Ship It — CICD & Free Deployment/
│   │   ├── 07_Conclusion/
│   │   └── Course Build a Full-Stack Web App with Flutter & Spring Boot_Full.md
│   ├── YoutubeScrapper/                                 # Audio & Session transcripts
│   │   ├── 001 - full-stack-AI-with-flutter-spring-boot kickoff Class.md
│   │   ├── 002 - Session  Weekly Support 01   Full-Stack Web Development with Flutter & Spring Boot.flac
│   │   └── 002 - Session  Weekly Support 01   Full-Stack Web Development with Flutter & Spring Boot.md
│   ├── Requirement Gathering.png                        # Requirement gathering flow diagram
│   └── REQUIREMENTS.md                                  # Consolidated Single SRS Specification
│
├── vms-frontend/                                        # Frontend Project (Flutter Web)
│   ├── .gitignore
│   ├── pubspec.yaml
│   ├── analysis_options.yaml
│   ├── web/
│   │   ├── favicon.png
│   │   ├── index.html
│   │   └── manifest.json
│   ├── assets/
│   │   ├── images/
│   │   └── mock_data/
│   │       └── vehicles_mock.json
│   ├── lib/
│   │   ├── main.dart
│   │   ├── core/
│   │   │   ├── constants/
│   │   │   │   ├── api_constants.dart
│   │   │   │   └── app_colors.dart
│   │   │   ├── network/
│   │   │   │   └── api_client.dart
│   │   │   ├── theme/
│   │   │   │   └── app_theme.dart
│   │   │   └── utils/
│   │   │       └── validators.dart
│   │   ├── features/
│   │   │   ├── auth/
│   │   │   │   ├── data/
│   │   │   │   │   └── auth_model.dart
│   │   │   │   ├── presentation/
│   │   │   │   │   └── login_screen.dart
│   │   │   │   └── services/
│   │   │   │       └── auth_service.dart
│   │   │   ├── vehicles/
│   │   │   │   ├── data/
│   │   │   │   │   └── vehicle_model.dart
│   │   │   │   ├── presentation/
│   │   │   │   │   ├── vehicle_list_screen.dart
│   │   │   │   │   └── vehicle_form_screen.dart
│   │   │   │   └── services/
│   │   │   │       └── vehicle_service.dart
│   │   │   ├── documents/
│   │   │   │   └── presentation/
│   │   │   ├── maintenance/
│   │   │   │   └── presentation/
│   │   │   ├── drivers/
│   │   │   │   └── presentation/
│   │   │   └── dashboard/
│   │   │       └── presentation/
│   │   │           └── dashboard_screen.dart
│   │   └── shared/
│   │       └── widgets/
│   │           ├── app_shell.dart
│   │           ├── custom_button.dart
│   │           └── status_badge.dart
│   └── test/
│       └── widget_test.dart
│
├── vms-backend/                                         # Backend Project (Spring Boot)
│   ├── .gitignore
│   ├── pom.xml
│   ├── src/
│   │   ├── main/
│   │   │   ├── java/
│   │   │   │   └── com/
│   │   │   │       └── starkgroup/
│   │   │   │           └── vms/
│   │   │   │               ├── VmsApplication.java
│   │   │   │               ├── config/
│   │   │   │               │   ├── CorsConfig.java
│   │   │   │               │   └── SecurityConfig.java
│   │   │   │               ├── controller/
│   │   │   │               │   ├── AuthController.java
│   │   │   │               │   └── VehicleController.java
│   │   │   │               ├── dto/
│   │   │   │               │   ├── request/
│   │   │   │               │   │   ├── LoginRequestDto.java
│   │   │   │               │   │   └── VehicleRequestDto.java
│   │   │   │               │   └── response/
│   │   │   │               │       ├── AuthResponseDto.java
│   │   │   │               │       ├── ErrorResponseDto.java
│   │   │   │               │       └── VehicleResponseDto.java
│   │   │   │               ├── entity/
│   │   │   │               │   ├── User.java
│   │   │   │               │   └── Vehicle.java
│   │   │   │               ├── exception/
│   │   │   │               │   ├── DuplicateVehicleException.java
│   │   │   │               │   ├── GlobalExceptionHandler.java
│   │   │   │               │   └── ResourceNotFoundException.java
│   │   │   │               ├── repository/
│   │   │   │               │   ├── UserRepository.java
│   │   │   │               │   └── VehicleRepository.java
│   │   │   │               └── service/
│   │   │   │                   ├── AuthService.java
│   │   │   │                   ├── VehicleService.java
│   │   │   │                   └── impl/
│   │   │   │                       ├── AuthServiceImpl.java
│   │   │   │                       └── VehicleServiceImpl.java
│   │   │   └── resources/
│   │   │       ├── application.properties
│   │   │       └── application-dev.properties
│   │   └── test/
│   │       └── java/
│   │           └── com/
│   │               └── starkgroup/
│   │                   └── vms/
│   │                       ├── VmsApplicationTests.java
│   │                       ├── controller/
│   │                       │   └── VehicleControllerTest.java
│   │                       └── service/
│   │                           └── VehicleServiceTest.java
│
├── commands/                                                                 # Developer CLI command guide & execution references
│   └── COMMAND_GUIDE.md                                                      # Maven & Flutter CLI cheat sheet
├── project status/                                                           # Project status & lifecycle implementation audit
│   └── PROJECT_STATUS.md                                                     # Completed vs remaining task breakdown across all 8 steps
├── Generic_Project_Template/                                                 # Framework-agnostic universal project templates
│   ├── TEMPLATE_GUIDELINE.md                                                 # Methodology guide & separation boundary
│   └── Any Project Skill.docx                                                # Master 8-step universal engineering blueprint
├── FOLDER_STRUCTURE.md                                                       # Official & merged architecture manual
└── README.md                                                                 # Project overview & quickstart
```

---

## 4. Engineering Reason Behind the Merged Structure

1. **Independent Stack Lifecycle & Decoupling**:
   - Flutter Web and Spring Boot run on completely distinct runtimes (Dart/CanvasKit vs JVM). Placing them in independent top-level subdirectories (`vms-frontend/` and `vms-backend/`) prevents build tool collision, circular dependency problems, and pollution of git histories.
2. **Simplified CI/CD & Cloud Deployment**:
   - **Netlify**: Connects directly to the repository with base directory set to `vms-frontend`, running `flutter build web --release` without touching Java files.
   - **Render**: Connects directly to `vms-backend`, executing `mvn clean package` and running the standalone Spring Boot JAR with environment variables (`SPRING_DATASOURCE_URL`, etc.) without touching Flutter code.
3. **Optimized AI-Assisted Development with Antigravity**:
   - When issuing micro-prompts to Google Antigravity (e.g. `@workspace Build the Vehicle REST API`), scoping the prompt or operating within `vms-backend` prevents the AI from generating unwanted Flutter widgets or corrupting frontend models.
4. **Step-by-Step Architectural Evolution**:
   - The project begins with mock data in `vms-frontend/assets/mock_data/vehicles_mock.json` to achieve complete UI verification before any backend integration. Once backend APIs are verified, swapping the mock repository for `vms-frontend/lib/core/network/api_client.dart` is clean, isolated, and reversible.
5. **Direct Alignment with Assignment 1 and Assignment 2**:
   - Assignment 1 (Login + Vehicle CRUD + Duplicate check) is fully isolated in `features/auth`, `features/vehicles`, `VehicleController`, and `VehicleService`.
   - Assignment 2 (Documents, Maintenance, Drivers, Dashboard) plugs directly into the pre-planned directories (`features/documents`, `features/maintenance`, `features/drivers`, `features/dashboard`) without refactoring existing code.

