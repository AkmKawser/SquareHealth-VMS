package com.starkgroup.vms.dto;

import com.starkgroup.vms.entity.Vehicle;
import com.starkgroup.vms.enums.ExpiryStatus;
import com.starkgroup.vms.enums.FuelType;
import com.starkgroup.vms.enums.VehicleStatus;
import com.starkgroup.vms.enums.VehicleType;

import java.math.BigDecimal;
import java.time.LocalDateTime;

public record VehicleResponseDto(
        Long id,
        String vehicleNumber,
        String company,
        VehicleType vehicleType,
        String brand,
        String model,
        Integer manufacturingYear,
        String color,
        Integer seatingCapacity,
        FuelType fuelType,
        VehicleStatus status,
        BigDecimal dailyRate,
        Integer fuelLevel,
        Integer odometerKm,
        String department,
        Long driverId,
        String driverName,
        String driverPhone,
        ExpiryStatus complianceStatus,
        LocalDateTime createdAt,
        LocalDateTime updatedAt
) {
    public static VehicleResponseDto from(Vehicle v, ExpiryStatus complianceStatus) {
        return new VehicleResponseDto(
                v.getId(),
                v.getVehicleNumber(),
                v.getCompany(),
                v.getVehicleType(),
                v.getBrand(),
                v.getModel(),
                v.getManufacturingYear(),
                v.getColor(),
                v.getSeatingCapacity(),
                v.getFuelType(),
                v.getStatus(),
                v.getDailyRate(),
                v.getFuelLevel(),
                v.getOdometerKm(),
                v.getDepartment(),
                v.getDriver() != null ? v.getDriver().getId() : null,
                v.getDriverName(),
                v.getDriverPhone(),
                complianceStatus,
                v.getCreatedAt(),
                v.getUpdatedAt()
        );
    }
}
