package com.starkgroup.vms.entity;

import jakarta.persistence.*;
import lombok.*;
import org.hibernate.annotations.CreationTimestamp;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
@Entity
@Table(name = "maintenance_logs")
public class MaintenanceLog {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "vehicle_id", nullable = false)
    private Vehicle vehicle;

    @Column(name = "service_date", nullable = false)
    private LocalDate serviceDate;

    @Column(name = "maintenance_type", nullable = false, length = 100)
    private String maintenanceType;

    @Column(name = "service_cost", nullable = false, precision = 12, scale = 2)
    @Builder.Default
    private BigDecimal serviceCost = BigDecimal.ZERO;

    @Column(name = "workshop_vendor", nullable = false, length = 150)
    private String workshopVendor;

    @Column(columnDefinition = "TEXT")
    private String notes;

    @Column(name = "service_odometer")
    private Integer serviceOdometer;

    @Column(name = "invoice_number", length = 80)
    private String invoiceNumber;

    @CreationTimestamp
    @Column(name = "created_at", nullable = false, updatable = false)
    private LocalDateTime createdAt;
}
