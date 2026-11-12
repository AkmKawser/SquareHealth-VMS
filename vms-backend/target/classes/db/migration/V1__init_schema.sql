-- =============================================================================
-- SquareHealth-VMS: Database Initialization Migration (V1)
-- Description: Core tables, foreign keys, constraints, and indexes
-- =============================================================================

-- 1. Companies Table (Multi-tenant ownership)
CREATE TABLE IF NOT EXISTS companies (
    id BIGSERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL UNIQUE,
    code VARCHAR(30) NOT NULL UNIQUE,
    address VARCHAR(255),
    contact_email VARCHAR(100),
    contact_phone VARCHAR(30),
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    created_at TIMESTAMP WITHOUT TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITHOUT TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- 2. Users Table (Authentication & RBAC)
CREATE TABLE IF NOT EXISTS users (
    id BIGSERIAL PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    email VARCHAR(100) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    full_name VARCHAR(100) NOT NULL,
    role VARCHAR(30) NOT NULL DEFAULT 'OPERATOR',
    company_id BIGINT REFERENCES companies(id) ON DELETE SET NULL,
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    created_at TIMESTAMP WITHOUT TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITHOUT TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- 3. Vehicles Table (Core Fleet Registry)
CREATE TABLE IF NOT EXISTS vehicles (
    id BIGSERIAL PRIMARY KEY,
    vehicle_number VARCHAR(50) NOT NULL UNIQUE,
    company_id BIGINT REFERENCES companies(id) ON DELETE RESTRICT,
    company_name VARCHAR(100) NOT NULL,
    type VARCHAR(50) NOT NULL,
    brand VARCHAR(50) NOT NULL,
    model VARCHAR(100) NOT NULL,
    year_of_manufacture INT,
    status VARCHAR(30) NOT NULL DEFAULT 'AVAILABLE',
    fuel_level INT NOT NULL DEFAULT 100 CHECK (fuel_level >= 0 AND fuel_level <= 100),
    fuel_capacity DECIMAL(8, 2) NOT NULL DEFAULT 65.00 CHECK (fuel_capacity > 0),
    odometer_reading DECIMAL(10, 2) NOT NULL DEFAULT 0.00 CHECK (odometer_reading >= 0),
    assigned_driver VARCHAR(100),
    department VARCHAR(100) NOT NULL DEFAULT 'General Logistics',
    created_at TIMESTAMP WITHOUT TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITHOUT TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Indexes for high-frequency queries
CREATE INDEX IF NOT EXISTS idx_vehicles_company_id ON vehicles(company_id);
CREATE INDEX IF NOT EXISTS idx_vehicles_status ON vehicles(status);
CREATE INDEX IF NOT EXISTS idx_vehicles_type ON vehicles(type);
CREATE INDEX IF NOT EXISTS idx_vehicles_number ON vehicles(vehicle_number);

-- 4. Trips Table (Fleet Dispatch & Mission Tracking)
CREATE TABLE IF NOT EXISTS trips (
    id BIGSERIAL PRIMARY KEY,
    vehicle_id BIGINT NOT NULL REFERENCES vehicles(id) ON DELETE RESTRICT,
    driver_name VARCHAR(100) NOT NULL,
    origin VARCHAR(150) NOT NULL,
    destination VARCHAR(150) NOT NULL,
    departure_time TIMESTAMP WITHOUT TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP,
    arrival_time TIMESTAMP WITHOUT TIME ZONE,
    start_odometer DECIMAL(10, 2) NOT NULL,
    end_odometer DECIMAL(10, 2),
    purpose VARCHAR(255),
    trip_status VARCHAR(30) NOT NULL DEFAULT 'IN_PROGRESS',
    created_at TIMESTAMP WITHOUT TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX IF NOT EXISTS idx_trips_vehicle_id ON trips(vehicle_id);
CREATE INDEX IF NOT EXISTS idx_trips_status ON trips(trip_status);

-- 5. Maintenance Logs Table (Service, Inspections & Repairs)
CREATE TABLE IF NOT EXISTS maintenance_logs (
    id BIGSERIAL PRIMARY KEY,
    vehicle_id BIGINT NOT NULL REFERENCES vehicles(id) ON DELETE CASCADE,
    service_type VARCHAR(50) NOT NULL,
    description TEXT NOT NULL,
    cost DECIMAL(10, 2) NOT NULL DEFAULT 0.00 CHECK (cost >= 0),
    service_date DATE NOT NULL,
    vendor_name VARCHAR(100),
    status VARCHAR(30) NOT NULL DEFAULT 'COMPLETED',
    created_at TIMESTAMP WITHOUT TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX IF NOT EXISTS idx_maint_vehicle_id ON maintenance_logs(vehicle_id);
CREATE INDEX IF NOT EXISTS idx_maint_date ON maintenance_logs(service_date);

-- 6. Fuel Logs Table (Fleet Economy & Consumption)
CREATE TABLE IF NOT EXISTS fuel_logs (
    id BIGSERIAL PRIMARY KEY,
    vehicle_id BIGINT NOT NULL REFERENCES vehicles(id) ON DELETE CASCADE,
    quantity_liters DECIMAL(8, 2) NOT NULL CHECK (quantity_liters > 0),
    cost_per_liter DECIMAL(8, 2) NOT NULL CHECK (cost_per_liter > 0),
    total_cost DECIMAL(10, 2) NOT NULL CHECK (total_cost > 0),
    odometer_reading DECIMAL(10, 2) NOT NULL CHECK (odometer_reading >= 0),
    station_name VARCHAR(100),
    fueled_at TIMESTAMP WITHOUT TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX IF NOT EXISTS idx_fuel_vehicle_id ON fuel_logs(vehicle_id);

-- 7. Telemetry Events Table (IoT Live Tracking)
CREATE TABLE IF NOT EXISTS telemetry_events (
    id BIGSERIAL PRIMARY KEY,
    vehicle_id BIGINT NOT NULL REFERENCES vehicles(id) ON DELETE CASCADE,
    latitude DECIMAL(10, 7) NOT NULL,
    longitude DECIMAL(10, 7) NOT NULL,
    speed_kmh DECIMAL(6, 2) NOT NULL DEFAULT 0.00,
    heading_deg DECIMAL(5, 2),
    recorded_at TIMESTAMP WITHOUT TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX IF NOT EXISTS idx_telemetry_vehicle_time ON telemetry_events(vehicle_id, recorded_at DESC);

