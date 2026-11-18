package com.starkgroup.vms;

import com.starkgroup.vms.entity.Vehicle;
import com.starkgroup.vms.repository.VehicleRepository;
import org.springframework.boot.CommandLineRunner;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.annotation.Bean;

import java.util.List;

@SpringBootApplication
public class VmsApplication {

    public static void main(String[] args) {
        SpringApplication.run(VmsApplication.class, args);
    }

    @Bean
    public CommandLineRunner initDatabase(VehicleRepository vehicleRepository) {
        return args -> {
            if (vehicleRepository.count() == 0) {
                vehicleRepository.saveAll(List.of(
                    new Vehicle("DHAKA-METRO-GA-11-2233", "Stark Group", "Ambulance", "Toyota", "HiAce", "AVAILABLE"),
                    new Vehicle("DHAKA-METRO-CHA-44-5566", "Stark Industries", "Delivery Van", "Hyundai", "Mighty", "IN_TRIP"),
                    new Vehicle("DHAKA-METRO-BA-77-8899", "Stark Medical", "Microbus", "Toyota", "Noah", "MAINTENANCE"),
                    new Vehicle("DHAKA-METRO-GHA-12-3456", "Stark Group", "Ambulance", "Nissan", "Caravan", "AVAILABLE"),
                    new Vehicle("DHAKA-METRO-DHA-98-7654", "Stark Logistics", "Executive Sedan", "Honda", "Civic", "AVAILABLE"),
                    new Vehicle("DHAKA-METRO-JA-55-6677", "Stark Industries", "Delivery Van", "Isuzu", "N-Series", "IN_TRIP"),
                    new Vehicle("DHAKA-METRO-HA-33-4455", "Stark Medical", "Ambulance", "Mercedes-Benz", "Sprinter", "AVAILABLE"),
                    new Vehicle("DHAKA-METRO-KA-88-9900", "Stark Group", "Microbus", "Toyota", "HiAce Commuter", "MAINTENANCE")
                ));
            }
        };
    }
}

