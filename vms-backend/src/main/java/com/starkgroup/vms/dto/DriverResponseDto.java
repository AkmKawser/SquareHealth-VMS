package com.starkgroup.vms.dto;

import com.starkgroup.vms.entity.Driver;

import java.time.LocalDate;
import java.time.LocalDateTime;

public record DriverResponseDto(
        Long id,
        String nationalId,
        String fullName,
        String licenseNumber,
        LocalDate licenseExpiryDate,
        String phone,
        String emergencyContact,
        Boolean medicalCleared,
        Boolean active,
        boolean eligible,
        LocalDateTime createdAt,
        LocalDateTime updatedAt
) {
    public static DriverResponseDto from(Driver d) {
        return new DriverResponseDto(
                d.getId(),
                d.getNationalId(),
                d.getFullName(),
                d.getLicenseNumber(),
                d.getLicenseExpiryDate(),
                d.getPhone(),
                d.getEmergencyContact(),
                d.getMedicalCleared(),
                d.getActive(),
                d.isEligible(),
                d.getCreatedAt(),
                d.getUpdatedAt()
        );
    }
}
