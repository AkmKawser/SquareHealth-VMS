package com.starkgroup.vms.service;

import com.starkgroup.vms.dto.VehicleDocumentResponseDto;
import com.starkgroup.vms.entity.Vehicle;
import com.starkgroup.vms.entity.VehicleDocument;
import com.starkgroup.vms.enums.DocumentType;
import com.starkgroup.vms.exception.BusinessRuleException;
import com.starkgroup.vms.exception.ResourceNotFoundException;
import com.starkgroup.vms.repository.VehicleDocumentRepository;
import com.starkgroup.vms.repository.VehicleRepository;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.core.io.Resource;
import org.springframework.core.io.UrlResource;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.StringUtils;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.net.MalformedURLException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.time.LocalDate;
import java.util.List;
import java.util.UUID;

@Service
public class DocumentService {

    private final VehicleDocumentRepository documentRepository;
    private final VehicleRepository vehicleRepository;
    private final AuditService auditService;
    private final Path uploadRoot;

    public DocumentService(
            VehicleDocumentRepository documentRepository,
            VehicleRepository vehicleRepository,
            AuditService auditService,
            @Value("${vms.storage.upload-dir:./uploads}") String uploadDir) {
        this.documentRepository = documentRepository;
        this.vehicleRepository = vehicleRepository;
        this.auditService = auditService;
        this.uploadRoot = Paths.get(uploadDir).toAbsolutePath().normalize();
    }

    @Transactional(readOnly = true)
    public List<VehicleDocumentResponseDto> getVehicleDocuments(Long vehicleId) {
        if (!vehicleRepository.existsById(vehicleId)) {
            throw new ResourceNotFoundException("Vehicle not found with id: " + vehicleId);
        }
        return documentRepository.findByVehicleIdOrderByUploadedAtDesc(vehicleId)
                .stream()
                .map(VehicleDocumentResponseDto::from)
                .toList();
    }

    @Transactional
    public VehicleDocumentResponseDto uploadDocument(
            Long vehicleId,
            MultipartFile file,
            DocumentType documentType,
            LocalDate expiryDate) {

        if (file == null || file.isEmpty()) {
            throw new BusinessRuleException("Uploaded file must not be empty.");
        }
        Vehicle vehicle = vehicleRepository.findById(vehicleId)
                .orElseThrow(() -> new ResourceNotFoundException("Vehicle not found with id: " + vehicleId));

        String originalName = StringUtils.cleanPath(file.getOriginalFilename() != null ? file.getOriginalFilename() : "document");
        String storedName = UUID.randomUUID() + "_" + originalName;

        try {
            Path vehicleDir = uploadRoot.resolve("vehicle_" + vehicleId);
            Files.createDirectories(vehicleDir);
            Path target = vehicleDir.resolve(storedName).normalize();
            if (!target.startsWith(vehicleDir)) {
                throw new BusinessRuleException("Invalid file path.");
            }
            Files.copy(file.getInputStream(), target, StandardCopyOption.REPLACE_EXISTING);

            VehicleDocument doc = VehicleDocument.builder()
                    .vehicle(vehicle)
                    .documentType(documentType)
                    .fileName(originalName)
                    .contentType(file.getContentType())
                    .fileSize(file.getSize())
                    .filePath(target.toString())
                    .expiryDate(expiryDate)
                    .build();

            VehicleDocument saved = documentRepository.save(doc);
            auditService.record("DOCUMENT", saved.getId(), "UPLOAD", null, documentType.name() + ":" + originalName);
            return VehicleDocumentResponseDto.from(saved);
        } catch (IOException e) {
            throw new BusinessRuleException("Failed to store uploaded file: " + e.getMessage());
        }
    }

    @Transactional(readOnly = true)
    public DocumentResource loadDocumentResource(Long documentId) {
        VehicleDocument doc = documentRepository.findById(documentId)
                .orElseThrow(() -> new ResourceNotFoundException("Document not found with id: " + documentId));
        try {
            Path filePath = Paths.get(doc.getFilePath()).normalize();
            Resource resource = new UrlResource(filePath.toUri());
            if (!resource.exists()) {
                throw new ResourceNotFoundException("File not found on disk for document id: " + documentId);
            }
            return new DocumentResource(doc, resource);
        } catch (MalformedURLException e) {
            throw new ResourceNotFoundException("Invalid file path for document id: " + documentId);
        }
    }

    @Transactional
    public void deleteDocument(Long documentId) {
        VehicleDocument doc = documentRepository.findById(documentId)
                .orElseThrow(() -> new ResourceNotFoundException("Document not found with id: " + documentId));
        try {
            Files.deleteIfExists(Paths.get(doc.getFilePath()));
        } catch (IOException ignored) {
        }
        documentRepository.delete(doc);
        auditService.record("DOCUMENT", documentId, "DELETE", doc.getFileName(), null);
    }

    public record DocumentResource(VehicleDocument document, Resource resource) {}
}
