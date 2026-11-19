package com.starkgroup.vms.repository;

import com.starkgroup.vms.entity.MaintenanceLog;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

import java.math.BigDecimal;
import java.util.List;

public interface MaintenanceLogRepository extends JpaRepository<MaintenanceLog, Long> {
    List<MaintenanceLog> findByVehicleIdOrderByServiceDateDescIdDesc(Long vehicleId);

    @Query("SELECT COALESCE(SUM(m.serviceCost), 0) FROM MaintenanceLog m")
    BigDecimal sumTotalMaintenanceCost();
}
