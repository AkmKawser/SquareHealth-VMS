# StarkGroup-VMS — Unified Modeling Language (UML) Architecture Specification

This document provides the formal architectural blueprint and object-oriented modeling suite for the **StarkGroup-VMS (Stark Group Vehicle Management System)**. It bridges the textual requirements defined in [system requirements.md](file:///c:/Users/HP/Documents/GitHub/SquareHealth-VMS/AI_Pair_Programming/System_Requirements/system%20requirements.md) directly into concrete structural, behavioral, and deployment blueprints.

---

## 1. UML Architecture Taxonomy

The system architecture is formalized through two complementary UML modeling pillars:

```mermaid
flowchart TD
    ROOT["SquareHealth-VMS UML Architecture"] --> BEH["Behavioral UML (Dynamic Workflows)"]
    ROOT --> STRUCT["Structural UML (Static Topology)"]

    BEH --> UC["1. Use Case Diagram\n(Actors & System Boundaries)"]
    BEH --> SEQ["2. Sequence Diagrams\n(API Request-Response Flows)"]
    BEH --> STM["3. State Machine Diagram\n(Vehicle Lifecycle States)"]
    BEH --> ACT["4. Activity Diagram\n(Duplicate Guard Decision Flow)"]

    STRUCT --> CLS["5. Domain Class Diagram\n(Entities, DTOs & Services)"]
    STRUCT --> CMP["6. Component Diagram\n(Clean 4-Tier Architecture)"]
    STRUCT --> DEP["7. Deployment Diagram\n(Cloud Infrastructure & Nodes)"]
```

---

## 2. Behavioral Modeling: System Use Case Diagram

The Use Case Diagram defines external actors and their direct interactions across system boundaries, enforcing the functional requirements (FR-01 through FR-10).

### 2.1 Actors Definition
1. **Fleet Manager**: Primary administrative operator managing fleet assets, registrations, and rental approvals.
2. **Fleet Operator / Staff**: Operational personnel executing daily check-ins, check-outs, and inspection logging.
3. **Maintenance Technician**: Specialized staff logging workshop service items, parts costs, and odometer intervals.
4. **System Administrator**: IT administrator managing user access, security roles, and system audit logs.

### 2.2 System Use Case Model

```mermaid
flowchart LR
    subgraph Actors["System Actors"]
        FM["Fleet Manager"]
        OP["Fleet Operator"]
        MT["Maintenance Tech"]
        SA["System Admin"]
    end

    subgraph Boundaries["SquareHealth-VMS Core System Boundary"]
        UC1["UC-01: Register Vehicle\n(FR-01)"]
        UC2["UC-02: Check Duplicate License\n(FR-02)"]
        UC3["UC-03: Search & Filter Fleet\n(FR-05)"]
        UC4["UC-04: View KPI Dashboard\n(FR-06)"]
        UC5["UC-05: Rent Vehicle to Driver\n(FR-03)"]
        UC6["UC-06: Return & Inspect Vehicle\n(FR-03)"]
        UC7["UC-07: Log Maintenance & Repair\n(FR-04)"]
        UC8["UC-08: Decommission Vehicle\n(FR-07)"]
        UC9["UC-09: Export Audit Reports\n(FR-10)"]
    end

    FM --> UC1
    FM --> UC3
    FM --> UC4
    FM --> UC5
    FM --> UC8
    FM --> UC9

    OP --> UC3
    OP --> UC5
    OP --> UC6

    MT --> UC7
    MT --> UC3

    SA --> UC9
    SA --> UC4

    UC1 -.->|"«include»"| UC2
    UC5 -.->|"«extend»"| UC3
    UC6 -.->|"«extend»"| UC7
```

---

## 3. Behavioral Modeling: Sequence Diagrams

### 3.1 Sequence 1: Vehicle Registration with Duplicate License Plate Guard (FR-01 & FR-02)
This sequence illustrates the end-to-end execution of registering a new corporate vehicle, verifying license plate uniqueness, and handling either `201 Created` or `409 Conflict`.

```mermaid
sequenceDiagram
    autonumber
    actor FM as Fleet Manager
    participant UI as Flutter Web UI
    participant Ctrl as VehicleController
    participant Val as ValidationService
    participant Svc as VehicleService
    participant Repo as VehicleRepository
    participant DB as PostgreSQL Database

    FM->>UI: Fills Registration Form (Plate, Brand, Model, Year, Rate)
    UI->>UI: Client-Side Regex Validation (Plate: [A-Z0-9-]{3,15})
    UI->>Ctrl: POST /api/v1/vehicles (VehicleRequestDto)
    Ctrl->>Val: validateVehiclePayload(dto)
    Val-->>Ctrl: Payload Validated

    Ctrl->>Svc: createVehicle(dto)
    Svc->>Repo: existsByVehicleNumberIgnoreCase(dto.vehicleNumber)
    Repo->>DB: SELECT COUNT(1) > 0 FROM vehicles WHERE UPPER(vehicle_number) = ?
    DB-->>Repo: Result (true / false)

    alt Duplicate Plate Found (Conflict)
        Repo-->>Svc: true (License Plate Exists)
        Svc-->>Ctrl: throw DuplicateVehicleException("Vehicle plate already exists")
        Ctrl-->>UI: HTTP 409 Conflict (ErrorResponseDto)
        UI-->>FM: Display Red Banner: "License plate already registered"
    else Unique Plate (Registration Success)
        Repo-->>Svc: false (Plate Unique)
        Svc->>Svc: Map DTO to Vehicle Entity (Set status = AVAILABLE)
        Svc->>Repo: save(vehicleEntity)
        Repo->>DB: INSERT INTO vehicles (...) VALUES (...)
        DB-->>Repo: Persisted Entity with Generated ID
        Repo-->>Svc: Saved Vehicle
        Svc-->>Ctrl: VehicleResponseDto
        Ctrl-->>UI: HTTP 201 Created (VehicleResponseDto)
        UI-->>FM: Toast Notification & Auto-Refresh Grid
    end
```

### 3.2 Sequence 2: Vehicle Rental Allocation Flow (FR-03)
This sequence details renting an available vehicle to a designated corporate driver, computing rental billing, and transitioning entity state.

```mermaid
sequenceDiagram
    autonumber
    actor OP as Fleet Operator
    participant UI as Flutter Web UI
    participant Ctrl as RentalController
    participant Svc as RentalService
    participant VRepo as VehicleRepository
    participant RRepo as RentalRepository
    participant DB as PostgreSQL Database

    OP->>UI: Selects Vehicle and Assigns Driver ID
    UI->>Ctrl: POST /api/v1/rentals (RentalBookingRequestDto)
    Ctrl->>Svc: bookVehicleRental(dto)
    Svc->>VRepo: findById(vehicleId)
    VRepo->>DB: SELECT * FROM vehicles WHERE id = ? FOR UPDATE
    DB-->>VRepo: Vehicle Record

    alt Vehicle is Not AVAILABLE
        VRepo-->>Svc: Vehicle.status != AVAILABLE
        Svc-->>Ctrl: throw IllegalStateException("Vehicle currently not available")
        Ctrl-->>UI: HTTP 400 Bad Request ("Vehicle is already rented or under maintenance")
        UI-->>OP: Display Warning Dialog
    else Vehicle is AVAILABLE
        VRepo-->>Svc: Vehicle Available
        Svc->>Svc: Calculate Estimated Cost (dailyRate * durationDays)
        Svc->>Svc: Update Vehicle State -> RENTED
        Svc->>VRepo: save(vehicle)
        Svc->>RRepo: save(rentalRecord)
        RRepo->>DB: INSERT INTO rental_records (...)
        VRepo->>DB: UPDATE vehicles SET status = 'RENTED' WHERE id = ?
        DB-->>Svc: Transaction Committed
        Svc-->>Ctrl: RentalBookingResponseDto
        Ctrl-->>UI: HTTP 201 Created
        UI-->>OP: Booking Confirmed & Digital Handover Agreement Generated
    end
```

---

## 4. Behavioral Modeling: Vehicle State Machine Diagram

The State Machine Diagram formalizes all valid lifecycle states and transition guards for the `Vehicle` entity, preventing illegal business operations (e.g., renting a vehicle currently in workshop maintenance).

```mermaid
stateDiagram-v2
    [*] --> AVAILABLE : Vehicle Registered & Certified (FR-01)
    
    AVAILABLE --> RENTED : Rental Agreement Signed (FR-03)
    RENTED --> AVAILABLE : Vehicle Returned (Inspection Passed)
    
    RENTED --> MAINTENANCE : Vehicle Returned with Damage/Defect (FR-04)
    AVAILABLE --> MAINTENANCE : Scheduled Odometer Service Due (FR-04)
    
    MAINTENANCE --> AVAILABLE : Work Order Completed & Inspected
    
    AVAILABLE --> RETIRED : End of Service Life / Sold (FR-07)
    MAINTENANCE --> RETIRED : Total Economic Loss / Write-Off
    
    RETIRED --> [*] : Archived & Historical Retained
```

### State Transition Invariant Table
| Current State | Target State | Triggering Event | Guard Condition |
|---|---|---|---|
| `AVAILABLE` | `RENTED` | `allocateRental()` | Driver license valid, security deposit cleared |
| `RENTED` | `AVAILABLE` | `returnVehicle()` | Inspection passed, zero mechanical faults |
| `RENTED` | `MAINTENANCE` | `reportDamageOnReturn()` | Fault logged, insurance claim initiated |
| `AVAILABLE` | `MAINTENANCE` | `scheduleService()` | Odometer threshold exceeded or periodic inspection |
| `MAINTENANCE` | `AVAILABLE` | `completeWorkOrder()` | Technician sign-off, road test cleared |
| `AVAILABLE` | `RETIRED` | `decommissionVehicle()` | Vehicle age > 10 yrs or salvage decision |

---

## 5. Behavioral Modeling: Activity Diagram

### Duplicate Detection & Registration Decision Flow

```mermaid
flowchart TD
    START(["Start: User Submits Vehicle Form"]) --> VAL{"Client Regex Check\nValid?"}
    VAL -->|No| ERR1["Show Field Error Validation"] --> STOP(["End: Correction Required"])
    VAL -->|Yes| POST["Send POST /api/v1/vehicles"]
    
    POST --> SVR_VAL{"Server Payload\nValid?"}
    SVR_VAL -->|No| ERR2["Return HTTP 400 Bad Request"] --> SHOW_ERR["Display API Error Toast"]
    SVR_VAL -->|Yes| DUP_QUERY["Execute existsByVehicleNumberIgnoreCase()"]
    
    DUP_QUERY --> DUP_CHECK{"License Plate\nExists in DB?"}
    DUP_CHECK -->|Yes| CONFLICT["Throw DuplicateVehicleException\nReturn HTTP 409 Conflict"] --> SHOW_ERR
    DUP_CHECK -->|No| TX_START["Begin DB Transaction"]
    
    TX_START --> SET_STATUS["Set Status = AVAILABLE\nSet Timestamps"]
    SET_STATUS --> INSERT["INSERT INTO vehicles"]
    INSERT --> AUDIT["Write System Audit Log Event"]
    AUDIT --> COMMIT["Commit Transaction"]
    COMMIT --> RESP["Return HTTP 201 Created"]
    RESP --> SUCCESS["Render Success Banner & Refresh Fleet Table"]
    SUCCESS --> DONE(["End: Registration Complete"])
```

---

## 6. Structural Modeling: Domain & Architecture Class Diagram

This class diagram defines the complete domain model, service layer contracts, repository interfaces, and Data Transfer Objects (DTOs) for the Spring Boot backend engine.

```mermaid
classDiagram
    class VehicleStatus {
        <<enumeration>>
        AVAILABLE
        RENTED
        MAINTENANCE
        RETIRED
    }

    class FuelType {
        <<enumeration>>
        PETROL
        OCTANE
        DIESEL
        HYBRID
        ELECTRIC
    }

    class Vehicle {
        -Long id
        -String vehicleNumber
        -String brand
        -String model
        -Integer manufacturingYear
        -VehicleStatus status
        -BigDecimal dailyRate
        -FuelType fuelType
        -Integer odometerKm
        -LocalDateTime createdAt
        -LocalDateTime updatedAt
        +isAvailable() Boolean
        +markRented() void
        +markAvailable() void
        +sendToMaintenance() void
        +retire() void
    }

    class Driver {
        -Long id
        -String nationalId
        -String fullName
        -String licenseNumber
        -String phone
        -Boolean active
        +isEligible() Boolean
    }

    class RentalBooking {
        -Long id
        -Vehicle vehicle
        -Driver driver
        -LocalDateTime startDate
        -LocalDateTime expectedReturnDate
        -LocalDateTime actualReturnDate
        -BigDecimal totalCost
        -String status
        +closeRental(LocalDateTime returnDate) void
    }

    class MaintenanceLog {
        -Long id
        -Vehicle vehicle
        -String description
        -BigDecimal serviceCost
        -Integer serviceOdometer
        -LocalDate serviceDate
        -String workshopVendor
    }

    class VehicleRequestDto {
        +String vehicleNumber
        +String brand
        +String model
        +Integer manufacturingYear
        +BigDecimal dailyRate
        +FuelType fuelType
    }

    class VehicleResponseDto {
        +Long id
        +String vehicleNumber
        +String brand
        +String model
        +Integer manufacturingYear
        +String status
        +BigDecimal dailyRate
        +LocalDateTime createdAt
    }

    class VehicleController {
        -VehicleService vehicleService
        +getAllVehicles(String status, String brand) ResponseEntity
        +getVehicleById(Long id) ResponseEntity
        +createVehicle(VehicleRequestDto dto) ResponseEntity
        +updateVehicle(Long id, VehicleRequestDto dto) ResponseEntity
        +deleteVehicle(Long id) ResponseEntity
    }

    class VehicleService {
        «Interface»
        +findAll(String status, String brand) List~VehicleResponseDto~
        +findById(Long id) VehicleResponseDto
        +create(VehicleRequestDto dto) VehicleResponseDto
        +update(Long id, VehicleRequestDto dto) VehicleResponseDto
        +delete(Long id) void
    }

    class VehicleServiceImpl {
        -VehicleRepository vehicleRepository
        -VehicleMapper vehicleMapper
        +findAll(String status, String brand) List~VehicleResponseDto~
        +create(VehicleRequestDto dto) VehicleResponseDto
    }

    class VehicleRepository {
        «Interface»
        +existsByVehicleNumberIgnoreCase(String plate) Boolean
        +findByStatus(VehicleStatus status) List~Vehicle~
        +findByBrandContainingIgnoreCase(String brand) List~Vehicle~
    }

    Vehicle --> VehicleStatus : has status
    Vehicle --> FuelType : uses fuel
    RentalBooking --> Vehicle : references
    RentalBooking --> Driver : booked by
    MaintenanceLog --> Vehicle : repairs
    VehicleController --> VehicleService : delegates to
    VehicleServiceImpl ..|> VehicleService : implements
    VehicleServiceImpl --> VehicleRepository : persists through
    VehicleController ..> VehicleRequestDto : accepts
    VehicleController ..> VehicleResponseDto : produces
```

---

## 7. Structural Modeling: Clean 4-Tier Component Diagram

The Component Diagram visualizes high cohesion and loose coupling across system layers, enforcing dependency inversion.

```mermaid
flowchart TD
    subgraph Tier1["1. Presentation Tier (Flutter Web & Browser)"]
        UI_VIEWS["UI Views & Screens\n(Dashboard, Fleet Grid, Form Modals)"]
        UI_STATE["State Management\n(Riverpod / Provider Controllers)"]
        UI_HTTP["REST HTTP Client\n(Dio / Mock Interceptors)"]
        UI_VIEWS --> UI_STATE --> UI_HTTP
    end

    subgraph Tier2["2. API & Controller Tier (Spring Web REST)"]
        API_CTRL["VehicleController\n(@RestController /api/v1/vehicles)"]
        API_EX["GlobalExceptionHandler\n(@ControllerAdvice)"]
        API_VALID["Bean Validation Layer\n(@Valid, Regex Guards)"]
        API_CTRL --> API_VALID
        API_CTRL --> API_EX
    end

    subgraph Tier3["3. Core Domain & Business Service Tier"]
        SVC_VEHICLE["VehicleService\n(Transactional Workflows)"]
        SVC_RENTAL["RentalService\n(Rate & Billing Computations)"]
        DOMAIN_MODEL["Domain Entities & Invariants\n(Vehicle, Driver, Booking)"]
        SVC_VEHICLE --> DOMAIN_MODEL
        SVC_RENTAL --> DOMAIN_MODEL
    end

    subgraph Tier4["4. Persistence & Database Infrastructure Tier"]
        REPO_JPA["Spring Data JPA Repositories\n(Hibernate ORM)"]
        FLYWAY["Flyway Migration Engine\n(V1__initial_schema.sql)"]
        RDBMS[("PostgreSQL 16 Engine\n(ACID Relational Storage)")]
        REPO_JPA --> RDBMS
        FLYWAY --> RDBMS
    end

    UI_HTTP -->|"JSON over HTTPS / REST"| API_CTRL
    API_CTRL -->|"Service Method Calls"| SVC_VEHICLE
    SVC_VEHICLE -->|"Query Methods"| REPO_JPA
```

---

## 8. Structural Modeling: Production Deployment Diagram

The Deployment Diagram details physical execution environments, network protocols, containerization boundaries, and external ports.

```mermaid
flowchart LR
    subgraph ClientDevice["Client Node: Fleet Operator Workstation"]
        BROWSER["Web Browser\n(Google Chrome / Edge / Safari)"]
        FLUTTER_WASM["Flutter Web App\n(CanvasKit & WebAssembly Runtime)"]
        BROWSER --- FLUTTER_WASM
    end

    subgraph CloudEdge["Edge Tier: Netlify Global CDN"]
        CDN["Netlify Static Host / Edge Proxy\n(HTTPS Port 443)\nServes: index.html, main.dart.js, assets/"]
    end

    subgraph ApplicationCloud["Application Tier: Render Container Platform"]
        DOCKER["Docker Container (Alpine Linux)"]
        TOMCAT["Embedded Apache Tomcat 10.x\n(Port 8080)"]
        JVM["Eclipse Temurin OpenJDK 25 Runtime"]
        APP_JAR["vms-backend.jar\n(Spring Boot 3.3.x Application)"]

        DOCKER --- TOMCAT
        TOMCAT --- JVM
        JVM --- APP_JAR
    end

    subgraph DatabaseCloud["Persistence Tier: Managed PostgreSQL Cloud"]
        PG_DB[("PostgreSQL 16 Instance\n(Port 5432 - SSL Required)\nTables: vehicles, drivers, rentals")]
    end

    FLUTTER_WASM -->|"HTTPS / Asset Fetch"| CDN
    FLUTTER_WASM -->|"HTTPS REST API Requests\n(/api/v1/vehicles)"| TOMCAT
    APP_JAR -->|"JDBC over TLS (Port 5432)"| PG_DB
```

---

## 9. Requirements Traceability Matrix (RTM) to UML Artifacts

| Functional Requirement | Core UML Artifact | Description of Coverage |
|---|---|---|
| **FR-01: Vehicle Registration** | Use Case (`UC-01`), Sequence (`3.1`), Class (`Vehicle`, `VehicleRequestDto`) | Form fields, entity persistence, format regex validation. |
| **FR-02: Duplicate License Plate Guard** | Sequence (`3.1`), Activity Diagram, Repository (`existsByVehicleNumberIgnoreCase`) | Database check, 409 Conflict error envelope. |
| **FR-03: Vehicle Status & Rental** | Use Case (`UC-05`), Sequence (`3.2`), State Machine Diagram | Atomic state transitions between `AVAILABLE` and `RENTED`. |
| **FR-04: Maintenance Work Orders** | Use Case (`UC-07`), State Machine Diagram, Class (`MaintenanceLog`) | Transition to `MAINTENANCE`, expense tracking. |
| **FR-05: Real-Time Fleet Multi-Filter** | Use Case (`UC-03`), Component Diagram | Controller query parameters (`status`, `brand`). |
| **FR-06: Executive Dashboard Metrics** | Use Case (`UC-04`), Component Diagram | Aggregation endpoints for fleet status distribution. |
| **FR-07: Vehicle Retirement** | Use Case (`UC-08`), State Machine Diagram | Terminal state transition to `RETIRED`. |
| **FR-10: System Audit Logging** | Use Case (`UC-09`), Activity Diagram | Audited transaction boundary before commit. |

---

## 10. Summary & Downstream Implementation Directives

1. **For Database Generation**: Use the **Class Diagram** (Section 6) and **State Machine Diagram** (Section 4) to verify columns, types, and check constraints for [STEP_4_DATABASE_SPECIFICATION.md](file:///c:/Users/HP/Documents/GitHub/SquareHealth-VMS/AI_Pair_Programming/query/specifications/STEP_4_DATABASE_SPECIFICATION.md).
2. **For Spring Boot Controllers & Services**: Follow the **Sequence Diagrams** (Section 3) to implement method contracts, exceptions, and DTO mappings for [STEP_5_BACKEND_SPECIFICATION.md](file:///c:/Users/HP/Documents/GitHub/SquareHealth-VMS/AI_Pair_Programming/query/specifications/STEP_5_BACKEND_SPECIFICATION.md).
3. **For Frontend Development**: Bind UI screens and validation alerts according to the **Activity Diagram** (Section 5) and **Component Diagram** (Section 7).
