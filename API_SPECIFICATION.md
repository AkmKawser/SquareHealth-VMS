# SquareHealth-VMS — Centralized API Specification & Data Contracts

This document formalizes the canonical REST API data contracts, DTO schemas, and error envelopes shared between the **Flutter Web Client** (`vms-frontend`) and the **Spring Boot Backend** (`vms-backend`).

---

## 1. Global Architectural Standards

* **Base URL**: `/api/v1`
* **Content-Type**: `application/json`
* **Authentication**: `Authorization: Bearer <JWT_TOKEN>` (Public: `/api/v1/auth/**`)
* **Naming Convention**: `camelCase` for all JSON properties and DTO attributes.

---

## 2. Standardized Error Response Envelope

All error responses return a uniform `ErrorResponseDto` envelope:

```json
{
  "timestamp": "2026-11-12T03:00:00Z",
  "status": 409,
  "error": "Conflict",
  "message": "Vehicle with number 'DHAKA-METRO-GA-11-2233' already exists in the fleet.",
  "path": "/api/v1/vehicles"
}
```

### Standard Status Codes

| Code | Reason | Description |
|---|---|---|
| `200 OK` | Success | Request succeeded with body. |
| `201 Created` | Created | Resource successfully created. Returns created object with assigned ID. |
| `204 No Content` | Deleted | Resource successfully deleted. Empty response body. |
| `400 Bad Request` | Validation Error | Missing mandatory fields, invalid format, or boundary violation. |
| `401 Unauthorized` | Auth Error | Missing, expired, or invalid Bearer JWT token. |
| `404 Not Found` | Resource Missing | Target entity ID does not exist in the database. |
| `409 Conflict` | Duplicate Record | Uniqueness constraint violation (e.g. duplicate license plate / VIN). |

---

## 3. Endpoints & Data Contracts

### 3.1 Authentication

#### `POST /api/v1/auth/login`
Authenticates a corporate fleet operator.

* **Request Body (`LoginRequestDto`)**:
```json
{
  "username": "admin",
  "password": "Password123!"
}
```
* **Response `200 OK` (`AuthResponseDto`)**:
```json
{
  "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "username": "admin",
  "role": "ROLE_ADMIN",
  "name": "Fleet Administrator"
}
```
* **Response `401 Unauthorized`**: Invalid credentials.

---

### 3.2 Vehicle Management

#### `GET /api/v1/vehicles`
Retrieves a list of fleet vehicles with optional filtering.

* **Query Parameters (Optional)**:
  * `status`: Filter by status (`AVAILABLE`, `IN_TRIP`, `MAINTENANCE`)
  * `search`: Case-insensitive search on vehicle number or company
* **Response `200 OK` (`List<VehicleResponseDto>`)**:
```json
[
  {
    "id": 1,
    "vehicleNumber": "DHAKA-METRO-GA-11-2233",
    "company": "Square Health",
    "type": "Ambulance",
    "brand": "Toyota",
    "model": "HiAce",
    "status": "AVAILABLE"
  },
  {
    "id": 2,
    "vehicleNumber": "DHAKA-METRO-CHA-44-5566",
    "company": "Stark Logistics",
    "type": "Delivery Van",
    "brand": "Hyundai",
    "model": "Mighty",
    "status": "IN_TRIP"
  }
]
```

---

#### `POST /api/v1/vehicles`
Registers a new vehicle in the fleet registry.

* **Request Body (`VehicleRequestDto`)**:
```json
{
  "vehicleNumber": "DHAKA-METRO-BA-99-0011",
  "company": "Square Pharma",
  "type": "Microbus",
  "brand": "Toyota",
  "model": "Noah",
  "status": "AVAILABLE"
}
```
* **Validation Rules**:
  * `vehicleNumber`: Required, non-empty, regex `^[A-Z0-9-]+$`.
  * `company`: Required, non-empty.
  * `type`: Required, non-empty.
  * `brand`: Required, non-empty.
  * `model`: Required, non-empty.
  * `status`: Must be one of `AVAILABLE`, `IN_TRIP`, `MAINTENANCE`.
* **Response `201 Created` (`VehicleResponseDto`)**: Returns the created entity with database generated `id`.
* **Response `409 Conflict`**: If `vehicleNumber` already exists in fleet.

---

#### `GET /api/v1/vehicles/{id}`
Retrieves details of a specific vehicle.

* **Path Variable**: `id` (Long)
* **Response `200 OK` (`VehicleResponseDto`)**
* **Response `404 Not Found`**: When no vehicle matches ID.

---

#### `PUT /api/v1/vehicles/{id}`
Updates an existing vehicle record.

* **Path Variable**: `id` (Long)
* **Request Body (`VehicleRequestDto`)**
* **Response `200 OK` (`VehicleResponseDto`)**
* **Response `404 Not Found`**: ID does not exist.
* **Response `409 Conflict`**: If updating `vehicleNumber` to one already taken by another vehicle.

---

#### `DELETE /api/v1/vehicles/{id}`
Removes a vehicle from active fleet registry.

* **Path Variable**: `id` (Long)
* **Response `204 No Content`**
* **Response `404 Not Found`**: When no vehicle matches ID.

---

### 3.3 Dashboard Overview

#### `GET /api/v1/dashboard/stats`
Retrieves aggregated executive KPIs for the fleet overview screen.

* **Response `200 OK` (`DashboardStatsDto`)**:
```json
{
  "totalVehicles": 24,
  "availableVehicles": 16,
  "inTripVehicles": 5,
  "maintenanceVehicles": 3,
  "totalDrivers": 18,
  "activeTrips": 5
}
```

---

