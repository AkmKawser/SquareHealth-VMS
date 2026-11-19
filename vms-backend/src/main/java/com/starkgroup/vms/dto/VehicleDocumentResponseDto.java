package com.starkgroup.vms.dto;

import com.starkgroup.vms.entity.VehicleDocument;
import com.starkgroup.vms.enums.DocumentType;
import com.starkgroup.vms.enums.ExpiryStatus;

import java.time.LocalDate;
import java.time.LocalDateTime;

public record VehicleDocumentResponseDto(
        Long id,
        Long vehicleId,
        DocumentType documentType,
        String fileName,
        String contentType,
        Long fileSize,
        String downloadUrl,
        LocalDate expiryDate,
        ExpiryStatus expiryStatus,
        LocalDateTime uploadedAt
) {
    public static VehicleDocumentResponseDto from(VehicleDocument doc) {
        return new VehicleDocumentResponseDto(
                doc.getId(),
                doc.getVehicle().getId(),
                doc.getDocumentType(),
                doc.getFileName(),
                doc.getContentType(),
                doc.getFileSize(),
                "/api/v1/documents/" + doc.getId() + "/download",
                doc.getExpiryDate(),
                doc.computeExpiryStatus(),
                doc.getUploadedAt()
        );
    }
}
