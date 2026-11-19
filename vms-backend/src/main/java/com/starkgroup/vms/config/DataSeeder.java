package com.starkgroup.vms.config;

import com.starkgroup.vms.entity.Driver;
import com.starkgroup.vms.entity.MaintenanceLog;
import com.starkgroup.vms.entity.User;
import com.starkgroup.vms.entity.Vehicle;
import com.starkgroup.vms.enums.FuelType;
import com.starkgroup.vms.enums.Role;
import com.starkgroup.vms.enums.VehicleStatus;
import com.starkgroup.vms.enums.VehicleType;
import com.starkgroup.vms.repository.DriverRepository;
import com.starkgroup.vms.repository.MaintenanceLogRepository;
import com.starkgroup.vms.repository.UserRepository;
import com.starkgroup.vms.repository.VehicleRepository;
import org.springframework.boot.CommandLineRunner;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Component;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.List;

@Component
public class DataSeeder implements CommandLineRunner {

    private final UserRepository userRepository;
    private final DriverRepository driverRepository;
    private final VehicleRepository vehicleRepository;
    private final MaintenanceLogRepository maintenanceLogRepository;
    private final PasswordEncoder passwordEncoder;

    public DataSeeder(
            UserRepository userRepository,
            DriverRepository driverRepository,
            VehicleRepository vehicleRepository,
            MaintenanceLogRepository maintenanceLogRepository,
            PasswordEncoder passwordEncoder) {
        this.userRepository = userRepository;
        this.driverRepository = driverRepository;
        this.vehicleRepository = vehicleRepository;
        this.maintenanceLogRepository = maintenanceLogRepository;
        this.passwordEncoder = passwordEncoder;
    }

    @Override
    public void run(String... args) {
        seedUsers();
        List<Driver> drivers = seedDrivers();
        seedVehicles(drivers);
    }

    private void seedUsers() {
        if (userRepository.count() > 0) return;

        userRepository.saveAll(List.of(
                User.builder()
                        .username("admin")
                        .passwordHash(passwordEncoder.encode("admin123"))
                        .fullName("Stark Group System Admin")
                        .company("Stark Group")
                        .role(Role.ADMIN)
                        .active(true)
                        .build(),
                User.builder()
                        .username("manager")
                        .passwordHash(passwordEncoder.encode("manager123"))
                        .fullName("Fleet Operations Manager")
                        .company("Stark Logistics")
                        .role(Role.FLEET_MANAGER)
                        .active(true)
                        .build(),
                User.builder()
                        .username("dispatcher")
                        .passwordHash(passwordEncoder.encode("dispatcher123"))
                        .fullName("Central Fleet Dispatcher")
                        .company("Apex Pharma")
                        .role(Role.DISPATCHER)
                        .active(true)
                        .build()
        ));
    }

    private List<Driver> seedDrivers() {
        if (driverRepository.count() > 0) {
            return driverRepository.findAll();
        }
        return driverRepository.saveAll(List.of(
                Driver.builder().nationalId("NID-1001").fullName("Rahim Uddin").licenseNumber("DL-DHA-2026-001")
                        .licenseExpiryDate(LocalDate.now().plusYears(2)).phone("+8801711000001")
                        .emergencyContact("+8801711990001").medicalCleared(true).active(true).build(),
                Driver.builder().nationalId("NID-1002").fullName("Karim Ahmed").licenseNumber("DL-DHA-2026-002")
                        .licenseExpiryDate(LocalDate.now().plusYears(1)).phone("+8801811000002")
                        .emergencyContact("+8801811990002").medicalCleared(true).active(true).build(),
                Driver.builder().nationalId("NID-1003").fullName("Hasan Mahmud").licenseNumber("DL-DHA-2026-003")
                        .licenseExpiryDate(LocalDate.now().plusMonths(18)).phone("+8801911000003")
                        .emergencyContact("+8801911990003").medicalCleared(true).active(true).build(),
                Driver.builder().nationalId("NID-1004").fullName("Tariqul Islam").licenseNumber("DL-DHA-2026-004")
                        .licenseExpiryDate(LocalDate.now().plusMonths(9)).phone("+8801611000004")
                        .emergencyContact("+8801611990004").medicalCleared(true).active(true).build(),
                Driver.builder().nationalId("NID-1005").fullName("Sajidul Haque").licenseNumber("DL-DHA-2026-005")
                        .licenseExpiryDate(LocalDate.now().plusYears(3)).phone("+8801511000005")
                        .emergencyContact("+8801511990005").medicalCleared(true).active(true).build(),
                Driver.builder().nationalId("NID-1006").fullName("Kamrul Hasan").licenseNumber("DL-DHA-2026-006")
                        .licenseExpiryDate(LocalDate.now().plusDays(15)).phone("+8801311000006")
                        .emergencyContact("+8801311990006").medicalCleared(true).active(true).build()
        ));
    }

    private void seedVehicles(List<Driver> drivers) {
        if (vehicleRepository.count() > 0) return;

        Driver d0 = drivers.isEmpty() ? null : drivers.get(0);
        Driver d1 = drivers.size() > 1 ? drivers.get(1) : null;
        Driver d2 = drivers.size() > 2 ? drivers.get(2) : null;

        List<Vehicle> seeded = vehicleRepository.saveAll(List.of(
                buildVehicle("DHAKA-METRO-GA-11-2233", "Stark Group", VehicleType.AMBULANCE, "Toyota", "HiAce ICU", 2023, "White", 6, FuelType.DIESEL, VehicleStatus.AVAILABLE, 85, d0),
                buildVehicle("DHAKA-METRO-GA-12-3456", "Stark Group", VehicleType.CAR, "Toyota", "Corolla Altis", 2022, "Silver", 5, FuelType.HYBRID, VehicleStatus.IN_USE, 72, d1),
                buildVehicle("DHAKA-METRO-CHA-51-8890", "Stark Logistics", VehicleType.MICROBUS, "Hyundai", "Grand Starex", 2021, "Navy", 11, FuelType.DIESEL, VehicleStatus.ACTIVE, 60, d2),
                buildVehicle("DHAKA-METRO-TA-14-4411", "Stark Logistics", VehicleType.TRUCK, "Isuzu", "NPR Cargo", 2020, "White", 3, FuelType.DIESEL, VehicleStatus.MAINTENANCE, 45, null),
                buildVehicle("DHAKA-METRO-DA-19-7721", "Apex Pharma", VehicleType.VAN, "Nissan", "NV350 Urvan", 2023, "Blue", 9, FuelType.PETROL, VehicleStatus.AVAILABLE, 92, null),
                buildVehicle("DHAKA-METRO-KHA-11-9012", "Stark Group", VehicleType.SUV, "Mitsubishi", "Pajero Sport", 2022, "Black", 7, FuelType.OCTANE, VehicleStatus.AVAILABLE, 78, null),
                buildVehicle("DHAKA-METRO-GA-21-5534", "Apex Pharma", VehicleType.VAN, "Toyota", "TownAce Refrigerated", 2021, "White", 2, FuelType.DIESEL, VehicleStatus.ACTIVE, 18, null),
                buildVehicle("DHAKA-METRO-MA-33-1120", "Stark Logistics", VehicleType.PICKUP, "Toyota", "Hilux Revo", 2023, "Grey", 5, FuelType.DIESEL, VehicleStatus.AVAILABLE, 88, null),
                buildVehicle("DHAKA-METRO-BA-08-6620", "Stark Group", VehicleType.BUS, "Hino", "AK1J Corporate", 2019, "Blue", 42, FuelType.CNG, VehicleStatus.INACTIVE, 35, null),
                buildVehicle("DHAKA-METRO-HA-44-3190", "Stark Logistics", VehicleType.MOTORCYCLE, "Honda", "CB150R", 2024, "Red", 2, FuelType.PETROL, VehicleStatus.AVAILABLE, 95, null),
                buildVehicle("DHAKA-METRO-GA-15-8080", "Apex Pharma", VehicleType.CAR, "Honda", "Civic", 2022, "Pearl White", 5, FuelType.HYBRID, VehicleStatus.AVAILABLE, 81, null),
                buildVehicle("DHAKA-METRO-CHA-52-4020", "Stark Group", VehicleType.AMBULANCE, "Mercedes-Benz", "Sprinter ALS", 2024, "White", 6, FuelType.DIESEL, VehicleStatus.AVAILABLE, 100, null),
                buildVehicle("DHAKA-METRO-TA-16-2299", "Stark Logistics", VehicleType.TRUCK, "Tata", "Ultra 1518", 2021, "Yellow", 3, FuelType.DIESEL, VehicleStatus.MAINTENANCE, 15, null),
                buildVehicle("DHAKA-METRO-GA-23-7171", "Stark Group", VehicleType.SUV, "Toyota", "Prado", 2023, "Black", 7, FuelType.OCTANE, VehicleStatus.ACTIVE, 65, null),
                buildVehicle("DHAKA-METRO-DA-20-6060", "Apex Pharma", VehicleType.VAN, "Suzuki", "Eeco Cargo", 2022, "Silver", 4, FuelType.CNG, VehicleStatus.AVAILABLE, 70, null),
                buildVehicle("DHAKA-METRO-KHA-18-5050", "Stark Group", VehicleType.CAR, "Hyundai", "Ioniq 5", 2024, "Cyber Grey", 5, FuelType.ELECTRIC, VehicleStatus.AVAILABLE, 94, null),
                buildVehicle("DHAKA-METRO-MA-31-9988", "Stark Logistics", VehicleType.PICKUP, "Ford", "Ranger", 2021, "Blue", 5, FuelType.DIESEL, VehicleStatus.INACTIVE, 40, null),
                buildVehicle("DHAKA-METRO-CHA-53-1212", "Stark Group", VehicleType.MICROBUS, "Toyota", "Coaster", 2020, "Beige", 28, FuelType.DIESEL, VehicleStatus.AVAILABLE, 55, null),
                buildVehicle("DHAKA-METRO-GA-29-4343", "Apex Pharma", VehicleType.CAR, "Toyota", "Premio", 2021, "Wine Red", 5, FuelType.OCTANE, VehicleStatus.AVAILABLE, 68, null),
                buildVehicle("DHAKA-METRO-TA-19-8765", "Stark Logistics", VehicleType.TRUCK, "Ashok Leyland", "Ecomet", 2022, "White", 3, FuelType.DIESEL, VehicleStatus.AVAILABLE, 77, null)
        ));

        if (maintenanceLogRepository.count() == 0 && !seeded.isEmpty()) {
            maintenanceLogRepository.saveAll(List.of(
                    MaintenanceLog.builder()
                            .vehicle(seeded.get(0))
                            .serviceDate(LocalDate.now().minusDays(20))
                            .maintenanceType("Periodic Inspection")
                            .serviceCost(new BigDecimal("4500.00"))
                            .workshopVendor("Navana Toyota Service Center")
                            .notes("Engine oil, oil filter, and oxygen system pressure check")
                            .serviceOdometer(24500)
                            .invoiceNumber("INV-2026-001")
                            .build(),
                    MaintenanceLog.builder()
                            .vehicle(seeded.get(3))
                            .serviceDate(LocalDate.now().minusDays(3))
                            .maintenanceType("Brake Overhaul")
                            .serviceCost(new BigDecimal("18200.00"))
                            .workshopVendor("Tejgaon Heavy Fleet Workshop")
                            .notes("Replaced front brake pads, rotors, and hydraulic fluid")
                            .serviceOdometer(68200)
                            .invoiceNumber("INV-2026-014")
                            .build()
            ));
        }
    }

    private Vehicle buildVehicle(
            String plate, String company, VehicleType type, String brand, String model,
            int year, String color, int seats, FuelType fuel, VehicleStatus status, int fuelLevel, Driver driver) {
        return Vehicle.builder()
                .vehicleNumber(plate)
                .company(company)
                .vehicleType(type)
                .brand(brand)
                .model(model)
                .manufacturingYear(year)
                .color(color)
                .seatingCapacity(seats)
                .fuelType(fuel)
                .status(status)
                .dailyRate(new BigDecimal("3500.00"))
                .fuelLevel(fuelLevel)
                .odometerKm(15000 + (year - 2019) * 3200)
                .department("Fleet Operations")
                .driver(driver)
                .driverName(driver != null ? driver.getFullName() : null)
                .driverPhone(driver != null ? driver.getPhone() : null)
                .build();
    }
}
