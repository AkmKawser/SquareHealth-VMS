package com.starkgroup.vms.dto;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;

import java.time.LocalDate;

public record DriverRequestDto(
        String nationalId,
        @NotBlank(message = "Driver full name is required") String fullName,
        @NotBlank(message = "License number is required") String licenseNumber,
        @NotNull(message = "License expiry date is required") LocalDate licenseExpiryDate,
        @NotBlank(message = "Phone number is required") String phone,
        String emergencyContact,
        Boolean medicalCleared,
        Boolean active
) {}
