-- =============================================================================
-- SquareHealth-VMS: Initial Seed Data Migration (V2)
-- Description: Baseline companies, administrative accounts, and initial vehicles
-- =============================================================================

-- Seed Companies
INSERT INTO companies (id, name, code, address, contact_email, contact_phone, is_active)
VALUES 
    (1, 'Square Health Ltd.', 'SQ-HLTH', 'Plot 48, Mohakhali C/A, Dhaka-1212', 'fleet@squarehealth.com.bd', '+880-2-8833047', TRUE),
    (2, 'Stark Group Logistics', 'STARK-LOG', 'Tejgaon Industrial Area, Dhaka-1208', 'dispatch@starkgroup.com', '+880-2-9887711', TRUE)
ON CONFLICT (id) DO NOTHING;

-- Seed Admin and Dispatcher Users (password hash for demonstration / bcrypt baseline)
INSERT INTO users (id, username, email, password_hash, full_name, role, company_id, is_active)
VALUES
    (1, 'admin', 'admin@squarehealth.com.bd', '$2a$10$wT8K8qH3Z2g1UqJpA8l3Ce6V0ZkH1vL9aB5rW4sY2uX7tM9nP1o2e', 'Fleet Administrator', 'ADMIN', 1, TRUE),
    (2, 'dispatcher', 'dispatcher@starkgroup.com', '$2a$10$wT8K8qH3Z2g1UqJpA8l3Ce6V0ZkH1vL9aB5rW4sY2uX7tM9nP1o2e', 'Lead Dispatcher', 'DISPATCHER', 2, TRUE)
ON CONFLICT (id) DO NOTHING;

-- Seed Initial Vehicles
INSERT INTO vehicles (id, vehicle_number, company_id, company_name, type, brand, model, year_of_manufacture, status, fuel_level, fuel_capacity, odometer_reading, assigned_driver, department)
VALUES
    (1, 'DHA-GA-11-2045', 1, 'Square Health Ltd.', 'Ambulance', 'Toyota', 'HiAce Emergency ICU', 2023, 'AVAILABLE', 92, 70.00, 14250.00, 'Md. Rafiqul Islam', 'Emergency Response Hub'),
    (2, 'DHA-MET-54-8890', 2, 'Stark Group Logistics', 'Logistics Van', 'Isuzu', 'NPR Cold Chain Reefer', 2022, 'ON_TRIP', 68, 100.00, 38920.00, 'Kazi Anisur Rahman', 'Pharma Supply Chain'),
    (3, 'DHA-GA-12-9901', 1, 'Square Health Ltd.', 'Executive Sedan', 'Toyota', 'Corolla Altis Hybrid', 2024, 'AVAILABLE', 84, 50.00, 5400.00, 'Abdul Malek', 'Executive Fleet'),
    (4, 'CTG-SHA-33-4120', 2, 'Stark Group Logistics', 'Logistics Van', 'Hyundai', 'H-1 Refrigerated Cargo', 2021, 'MAINTENANCE', 35, 75.00, 62100.00, 'Farhad Hossain', 'Chittagong Distribution Depot'),
    (5, 'DHA-HA-88-1234', 1, 'Square Health Ltd.', 'Ambulance', 'Toyota', 'HiAce Neonatal ICU', 2023, 'ON_TRIP', 96, 70.00, 8900.00, 'Nurul Amin', 'Pediatric Care Unit'),
    (6, 'DHA-GA-15-7762', 1, 'Square Health Ltd.', 'Dispatch Motorcycle', 'Honda', 'CB Shine 125cc', 2024, 'AVAILABLE', 75, 11.00, 2150.00, 'Zahid Hasan', 'Clinical Diagnostics Express')
ON CONFLICT (id) DO NOTHING;

-- Reset sequence IDs
SELECT setval('companies_id_seq', (SELECT MAX(id) FROM companies));
SELECT setval('users_id_seq', (SELECT MAX(id) FROM users));
SELECT setval('vehicles_id_seq', (SELECT MAX(id) FROM vehicles));

