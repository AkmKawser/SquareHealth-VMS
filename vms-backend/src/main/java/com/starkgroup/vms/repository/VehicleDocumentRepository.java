package com.starkgroup.vms.repository;

import com.starkgroup.vms.entity.VehicleDocument;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface VehicleDocumentRepository extends JpaRepository<VehicleDocument, Long> {
    List<VehicleDocument> findByVehicleIdOrderByUploadedAtDesc(Long vehicleId);
}
