package com.starkgroup.vms.entity;

import jakarta.persistence.*;
import lombok.*;
import org.hibernate.annotations.CreationTimestamp;
import org.hibernate.annotations.UpdateTimestamp;

import java.time.LocalDate;
import java.time.LocalDateTime;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
@Entity
@Table(name = "drivers")
public class Driver {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "national_id", unique = true, length = 50)
    private String nationalId;

    @Column(name = "full_name", nullable = false, length = 150)
    private String fullName;

    @Column(name = "license_number", nullable = false, unique = true, length = 80)
    private String licenseNumber;

    @Column(name = "license_expiry_date", nullable = false)
    private LocalDate licenseExpiryDate;

    @Column(nullable = false, length = 40)
    private String phone;

    @Column(name = "emergency_contact", length = 150)
    private String emergencyContact;

    @Column(name = "medical_cleared", nullable = false)
    @Builder.Default
    private Boolean medicalCleared = true;

    @Column(nullable = false)
    @Builder.Default
    private Boolean active = true;

    @CreationTimestamp
    @Column(name = "created_at", nullable = false, updatable = false)
    private LocalDateTime createdAt;

    @UpdateTimestamp
    @Column(name = "updated_at", nullable = false)
    private LocalDateTime updatedAt;

    public boolean isEligible() {
        return Boolean.TRUE.equals(active)
                && Boolean.TRUE.equals(medicalCleared)
                && licenseExpiryDate != null
                && !licenseExpiryDate.isBefore(LocalDate.now());
    }
}
