-- SquareHealth-VMS (Stark Group Fleet Management System)
-- V1: Initial PostgreSQL Schema

CREATE TABLE users (
    id BIGSERIAL PRIMARY KEY,
    username VARCHAR(100) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    full_name VARCHAR(150) NOT NULL,
    company VARCHAR(150) NOT NULL DEFAULT 'Stark Group',
    role VARCHAR(40) NOT NULL,
    active BOOLEAN NOT NULL DEFAULT TRUE,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE drivers (
    id BIGSERIAL PRIMARY KEY,
    national_id VARCHAR(50) UNIQUE,
    full_name VARCHAR(150) NOT NULL,
    license_number VARCHAR(80) NOT NULL UNIQUE,
    license_expiry_date DATE NOT NULL,
    phone VARCHAR(40) NOT NULL,
    emergency_contact VARCHAR(150),
    medical_cleared BOOLEAN NOT NULL DEFAULT TRUE,
    active BOOLEAN NOT NULL DEFAULT TRUE,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE vehicles (
    id BIGSERIAL PRIMARY KEY,
    vehicle_number VARCHAR(60) NOT NULL UNIQUE,
    company VARCHAR(150) NOT NULL DEFAULT 'Stark Group',
    vehicle_type VARCHAR(40) NOT NULL,
    brand VARCHAR(100) NOT NULL,
    model VARCHAR(100) NOT NULL,
    manufacturing_year INTEGER,
    color VARCHAR(50),
    seating_capacity INTEGER,
    fuel_type VARCHAR(30) NOT NULL,
    status VARCHAR(30) NOT NULL DEFAULT 'AVAILABLE',
    daily_rate NUMERIC(12, 2),
    fuel_level INTEGER DEFAULT 100,
    odometer_km INTEGER DEFAULT 0,
    department VARCHAR(150),
    driver_id BIGINT REFERENCES drivers(id) ON DELETE SET NULL,
    driver_name VARCHAR(150),
    driver_phone VARCHAR(40),
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE vehicle_documents (
    id BIGSERIAL PRIMARY KEY,
    vehicle_id BIGINT NOT NULL REFERENCES vehicles(id) ON DELETE CASCADE,
    document_type VARCHAR(40) NOT NULL,
    file_name VARCHAR(255) NOT NULL,
    content_type VARCHAR(120),
    file_size BIGINT,
    file_path VARCHAR(500) NOT NULL,
    expiry_date DATE,
    uploaded_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE maintenance_logs (
    id BIGSERIAL PRIMARY KEY,
    vehicle_id BIGINT NOT NULL REFERENCES vehicles(id) ON DELETE CASCADE,
    service_date DATE NOT NULL,
    maintenance_type VARCHAR(100) NOT NULL,
    service_cost NUMERIC(12, 2) NOT NULL DEFAULT 0,
    workshop_vendor VARCHAR(150) NOT NULL,
    notes TEXT,
    service_odometer INTEGER,
    invoice_number VARCHAR(80),
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE audit_logs (
    id BIGSERIAL PRIMARY KEY,
    entity_type VARCHAR(60) NOT NULL,
    entity_id BIGINT,
    action VARCHAR(40) NOT NULL,
    performed_by VARCHAR(100) NOT NULL,
    old_value TEXT,
    new_value TEXT,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_vehicles_status ON vehicles(status);
CREATE INDEX idx_vehicles_company ON vehicles(company);
CREATE INDEX idx_vehicles_type ON vehicles(vehicle_type);
CREATE INDEX idx_vehicles_driver_id ON vehicles(driver_id);
CREATE INDEX idx_docs_vehicle_id ON vehicle_documents(vehicle_id);
CREATE INDEX idx_docs_expiry_date ON vehicle_documents(expiry_date);
CREATE INDEX idx_maint_vehicle_id ON maintenance_logs(vehicle_id);
CREATE INDEX idx_maint_service_date ON maintenance_logs(service_date);
