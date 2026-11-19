package com.starkgroup.vms.controller;

import com.starkgroup.vms.dto.VehicleDocumentResponseDto;
import com.starkgroup.vms.enums.DocumentType;
import com.starkgroup.vms.service.DocumentService;
import org.springframework.core.io.Resource;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.time.LocalDate;
import java.util.List;

@RestController
@RequestMapping("/api/v1")
public class DocumentController {

    private final DocumentService documentService;

    public DocumentController(DocumentService documentService) {
        this.documentService = documentService;
    }

    @GetMapping("/vehicles/{vehicleId}/documents")
    public ResponseEntity<List<VehicleDocumentResponseDto>> getVehicleDocuments(@PathVariable Long vehicleId) {
        return ResponseEntity.ok(documentService.getVehicleDocuments(vehicleId));
    }

    @PostMapping(value = "/vehicles/{vehicleId}/documents", consumes = MediaType.MULTIPART_FORM_DATA_VALUE)
    @PreAuthorize("hasAnyRole('ADMIN', 'FLEET_MANAGER')")
    public ResponseEntity<VehicleDocumentResponseDto> uploadDocument(
            @PathVariable Long vehicleId,
            @RequestParam("file") MultipartFile file,
            @RequestParam("documentType") DocumentType documentType,
            @RequestParam(value = "expiryDate", required = false)
            @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate expiryDate) {
        return ResponseEntity.status(HttpStatus.CREATED)
                .body(documentService.uploadDocument(vehicleId, file, documentType, expiryDate));
    }

    @GetMapping("/documents/{documentId}/download")
    public ResponseEntity<Resource> downloadDocument(@PathVariable Long documentId) {
        DocumentService.DocumentResource docRes = documentService.loadDocumentResource(documentId);
        String contentType = docRes.document().getContentType() != null
                ? docRes.document().getContentType()
                : MediaType.APPLICATION_OCTET_STREAM_VALUE;
        return ResponseEntity.ok()
                .contentType(MediaType.parseMediaType(contentType))
                .header(HttpHeaders.CONTENT_DISPOSITION, "inline; filename=\"" + docRes.document().getFileName() + "\"")
                .body(docRes.resource());
    }

    @DeleteMapping("/documents/{documentId}")
    @PreAuthorize("hasAnyRole('ADMIN', 'FLEET_MANAGER')")
    public ResponseEntity<Void> deleteDocument(@PathVariable Long documentId) {
        documentService.deleteDocument(documentId);
        return ResponseEntity.noContent().build();
    }
}
