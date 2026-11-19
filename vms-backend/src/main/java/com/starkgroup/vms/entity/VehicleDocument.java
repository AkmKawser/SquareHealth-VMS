package com.starkgroup.vms.entity;

import com.starkgroup.vms.enums.DocumentType;
import com.starkgroup.vms.enums.ExpiryStatus;
import jakarta.persistence.*;
import lombok.*;
import org.hibernate.annotations.CreationTimestamp;

import java.time.LocalDate;
import java.time.LocalDateTime;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
@Entity
@Table(name = "vehicle_documents")
public class VehicleDocument {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "vehicle_id", nullable = false)
    private Vehicle vehicle;

    @Enumerated(EnumType.STRING)
    @Column(name = "document_type", nullable = false, length = 40)
    private DocumentType documentType;

    @Column(name = "file_name", nullable = false)
    private String fileName;

    @Column(name = "content_type", length = 120)
    private String contentType;

    @Column(name = "file_size")
    private Long fileSize;

    @Column(name = "file_path", nullable = false, length = 500)
    private String filePath;

    @Column(name = "expiry_date")
    private LocalDate expiryDate;

    @CreationTimestamp
    @Column(name = "uploaded_at", nullable = false, updatable = false)
    private LocalDateTime uploadedAt;

    public ExpiryStatus computeExpiryStatus() {
        if (expiryDate == null) {
            return ExpiryStatus.VALID;
        }
        LocalDate today = LocalDate.now();
        if (expiryDate.isBefore(today)) {
            return ExpiryStatus.EXPIRED;
        }
        if (!expiryDate.isAfter(today.plusDays(30))) {
            return ExpiryStatus.EXPIRING_SOON;
        }
        return ExpiryStatus.VALID;
    }
}
