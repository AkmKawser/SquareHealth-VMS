package com.starkgroup.vms.dto;

import com.starkgroup.vms.enums.FuelType;
import com.starkgroup.vms.enums.VehicleStatus;
import com.starkgroup.vms.enums.VehicleType;
import jakarta.validation.constraints.*;

import java.math.BigDecimal;

public record VehicleRequestDto(
        @NotBlank(message = "Vehicle number is required")
        @Size(min = 3, max = 60, message = "Vehicle number must be between 3 and 60 characters")
        String vehicleNumber,

        @NotBlank(message = "Company is required")
        String company,

        @NotNull(message = "Vehicle type is required")
        VehicleType vehicleType,

        @NotBlank(message = "Brand is required")
        String brand,

        @NotBlank(message = "Model is required")
        String model,

        @Min(value = 1900, message = "Manufacturing year must be at least 1900")
        Integer manufacturingYear,

        String color,

        @Positive(message = "Seating capacity must be positive")
        Integer seatingCapacity,

        @NotNull(message = "Fuel type is required")
        FuelType fuelType,

        VehicleStatus status,

        @DecimalMin(value = "0.0", message = "Daily rate cannot be negative")
        BigDecimal dailyRate,

        @Min(0) @Max(100)
        Integer fuelLevel,

        @Min(0)
        Integer odometerKm,

        String department,
        Long driverId,
        String driverName,
        String driverPhone
) {}
