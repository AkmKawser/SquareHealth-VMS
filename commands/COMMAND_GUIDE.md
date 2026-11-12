# SquareHealth-VMS — Developer CLI Command Guide

This guide documents the canonical, industry-standard Command Line Interface (CLI) commands to build, test, run, and manage both the **Java Spring Boot Backend** and **Flutter Web Frontend** for the SquareHealth-VMS platform.

---

## ⚡ Quick Start: Full-Stack Local Launch

To run the complete platform locally in development mode:

### 1. Terminal 1 — Start the Backend (Spring Boot on Port 8080)

```powershell
# Navigate to backend directory
cd vms-backend

# Launch with Maven Wrapper (Windows)
.\mvnw.cmd spring-boot:run

# Launch with Maven Wrapper (Linux / macOS)
./mvnw spring-boot:run
```

*The server will boot up with an in-memory database (`dev` profile) and listen on `.*

### 2. Terminal 2 — Start the Frontend (Flutter Web)

```powershell
# Navigate to frontend directory
cd vms-frontend

# Fetch dependencies
flutter pub get

# Launch in Chrome
flutter run -d chrome
```

---

## ☕ 1. Java Spring Boot Backend Commands (`vms-backend/`)

All backend commands utilize the bundled **Maven Wrapper (`mvnw` / `mvnw.cmd`)**, ensuring that any team member or CI/CD machine can build and execute the application with **zero pre-installed Maven dependencies**.

### 1.1 Running the Server

| Target Environment              | Windows Command                                                                 | Linux / macOS Command                                                       | Notes                                                              |
| ------------------------------- | ------------------------------------------------------------------------------- | --------------------------------------------------------------------------- | ------------------------------------------------------------------ |
| **Development (`dev`)** | `.\mvnw.cmd spring-boot:run`                                                  | `./mvnw spring-boot:run`                                                  | Uses H2 in-memory DB; starts instantly with no external DB needed. |
| **Production (`prod`)** | `.\mvnw.cmd spring-boot:run -Dspring-boot.run.profiles=prod`                  | `./mvnw spring-boot:run -Dspring-boot.run.profiles=prod`                  | Connects to PostgreSQL on `localhost:5432/vms_db`.               |
| **Custom Port**           | `.\mvnw.cmd spring-boot:run -Dspring-boot.run.arguments="--server.port=9090"` | `./mvnw spring-boot:run -Dspring-boot.run.arguments="--server.port=9090"` | Useful if port 8080 is already occupied.                           |

### 1.2 Compilation & Building

```powershell
# Clean previous build artifacts and compile Java classes
.\mvnw.cmd clean compile

# Package the application into an executable JAR file
.\mvnw.cmd clean package -DskipTests

# Run the packaged executable JAR directly with Java
java -jar target/vms-backend-0.0.1-SNAPSHOT.jar
```

### 1.3 Testing

```powershell
# Run all unit and integration tests (JUnit 5 & Mockito)
.\mvnw.cmd test

# Run a single specific test class (e.g. Duplicate Vehicle Rule test)
.\mvnw.cmd test -Dtest=VehicleServiceTest

# Run tests and generate Surefire HTML test reports
.\mvnw.cmd surefire-report:report
```

### 1.4 Database Migrations (Flyway)

```powershell
# Apply pending SQL migrations to the target database
.\mvnw.cmd flyway:migrate

# Check status and version history of applied migrations
.\mvnw.cmd flyway:info

# Validate applied migrations against disk scripts
.\mvnw.cmd flyway:validate
```

### 1.5 Health & Endpoint Verification

Once the backend is running, verify its status in PowerShell:

```powershell
# Check vehicle registry (empty list or seeded records)
Invoke-RestMethod -Uri "http://localhost:8080/api/v1/vehicles"

# Create a sample vehicle record
$body = @{
    vehicleNumber = "DHA-GA-11-2045"
    company = "Square Health"
    type = "Ambulance"
    brand = "Toyota"
    model = "HiAce GL"
    status = "Active"
} | ConvertTo-Json

Invoke-RestMethod -Uri "http://localhost:8080/api/v1/vehicles" -Method Post -Body $body -ContentType "application/json"
```

---

## 🎨 2. Flutter Web Frontend Commands (`vms-frontend/`)

All frontend commands utilize the official **Flutter SDK CLI (`flutter`)**.

### 2.1 Dependency Management

```powershell
# Resolve and download all pub packages specified in pubspec.yaml
flutter pub get

# Check for outdated packages
flutter pub outdated

# Upgrade packages within semantic constraints
flutter pub upgrade
```

### 2.2 Running Development Server

| Mode                          | Command                                       | Notes                                                                 |
| ----------------------------- | --------------------------------------------- | --------------------------------------------------------------------- |
| **Chrome Desktop**      | `flutter run -d chrome`                     | Launches Chrome with full Dart DevTools and hot-reload.               |
| **Specific Port**       | `flutter run -d chrome --web-port=3000`     | Fixes the origin to `http://localhost:3000` (matches backend CORS). |
| **Headless Web Server** | `flutter run -d web-server --web-port=3000` | Serves without opening a browser window; accessible from any client.  |

### 2.3 Code Analysis & Quality

```powershell
# Run Dart static code analyzer
flutter analyze

# Format all Dart files according to standard conventions
dart format lib/
```

### 2.4 Testing

```powershell
# Run all unit and widget tests
flutter test

# Run a specific widget test file
flutter test test/features/vehicles/vehicle_list_test.dart

# Run tests with code coverage output
flutter test --coverage
```

### 2.5 Production Build

```powershell
# Compile the Flutter web application to optimized static assets
flutter build web --release

# The compiled output is located in: vms-frontend/build/web/
```

---

## 🗄️ 3. Database Commands (PostgreSQL & Docker)

When running the backend in `prod` profile with full PostgreSQL persistence:

### 3.1 Docker Compose Execution

```powershell
# Start PostgreSQL in the background
docker compose up -d postgres

# Check container status
docker compose ps

# View PostgreSQL container logs
docker compose logs -f postgres

# Stop the database container
docker compose down
```

### 3.2 Direct PostgreSQL CLI (`psql`)

```powershell
# Connect to PostgreSQL running locally
psql -U postgres -h localhost -p 5432 -d vms_db

# Useful psql interactive commands:
# \l         -> List databases
# \dt        -> List all tables
# \d vehicles -> Inspect schema and constraints of vehicles table
# \q         -> Quit psql
```

---

## 🚨 4. Troubleshooting & FAQ

### Issue: Port 8080 Already in Use

If another process is using port 8080:

```powershell
# Identify process listening on port 8080 (Windows PowerShell)
Get-NetTCPConnection -LocalPort 8080 | Select-Object OwningProcess

# Terminate process if needed
Stop-Process -Id <PID> -Force

# Or launch Spring Boot on an alternate port
.\mvnw.cmd spring-boot:run -Dspring-boot.run.arguments="--server.port=8081"
```

### Issue: Permission Denied on `mvnw` (Linux / macOS)

If the Maven Wrapper script lacks executable permissions:

```bash
chmod +x vms-backend/mvnw
```
