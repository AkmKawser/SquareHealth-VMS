package com.starkgroup.vms.dto;

import com.starkgroup.vms.entity.MaintenanceLog;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;

public record MaintenanceResponseDto(
        Long id,
        Long vehicleId,
        LocalDate serviceDate,
        String maintenanceType,
        BigDecimal serviceCost,
        String workshopVendor,
        String notes,
        Integer serviceOdometer,
        String invoiceNumber,
        LocalDateTime createdAt
) {
    public static MaintenanceResponseDto from(MaintenanceLog log) {
        return new MaintenanceResponseDto(
                log.getId(),
                log.getVehicle().getId(),
                log.getServiceDate(),
                log.getMaintenanceType(),
                log.getServiceCost(),
                log.getWorkshopVendor(),
                log.getNotes(),
                log.getServiceOdometer(),
                log.getInvoiceNumber(),
                log.getCreatedAt()
        );
    }
}
