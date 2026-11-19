package com.starkgroup.vms.dto;

import jakarta.validation.constraints.DecimalMin;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;

import java.math.BigDecimal;
import java.time.LocalDate;

public record MaintenanceRequestDto(
        @NotNull(message = "Service date is required") LocalDate serviceDate,
        @NotBlank(message = "Maintenance type is required") String maintenanceType,
        @NotNull(message = "Service cost is required") @DecimalMin("0.0") BigDecimal serviceCost,
        @NotBlank(message = "Workshop vendor is required") String workshopVendor,
        String notes,
        Integer serviceOdometer,
        String invoiceNumber
) {}
