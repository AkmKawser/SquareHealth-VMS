package com.starkgroup.vms.service;

import com.starkgroup.vms.dto.DashboardStatsDto;
import com.starkgroup.vms.entity.VehicleDocument;
import com.starkgroup.vms.enums.ExpiryStatus;
import com.starkgroup.vms.enums.VehicleStatus;
import com.starkgroup.vms.repository.DriverRepository;
import com.starkgroup.vms.repository.MaintenanceLogRepository;
import com.starkgroup.vms.repository.VehicleDocumentRepository;
import com.starkgroup.vms.repository.VehicleRepository;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

@Service
public class DashboardService {

    private final VehicleRepository vehicleRepository;
    private final DriverRepository driverRepository;
    private final VehicleDocumentRepository documentRepository;
    private final MaintenanceLogRepository maintenanceLogRepository;

    public DashboardService(
            VehicleRepository vehicleRepository,
            DriverRepository driverRepository,
            VehicleDocumentRepository documentRepository,
            MaintenanceLogRepository maintenanceLogRepository) {
        this.vehicleRepository = vehicleRepository;
        this.driverRepository = driverRepository;
        this.documentRepository = documentRepository;
        this.maintenanceLogRepository = maintenanceLogRepository;
    }

    @Transactional(readOnly = true)
    public DashboardStatsDto getStats() {
        long total = vehicleRepository.count();
        long available = vehicleRepository.countByStatus(VehicleStatus.AVAILABLE);
        long active = vehicleRepository.countByStatus(VehicleStatus.ACTIVE)
                + vehicleRepository.countByStatus(VehicleStatus.IN_USE);
        long maintenance = vehicleRepository.countByStatus(VehicleStatus.MAINTENANCE);
        long inactive = vehicleRepository.countByStatus(VehicleStatus.INACTIVE);
        long drivers = driverRepository.count();
        long lowFuel = vehicleRepository.countByFuelLevelLessThanEqual(20);
        BigDecimal totalCost = maintenanceLogRepository.sumTotalMaintenanceCost();

        List<VehicleDocument> docs = documentRepository.findAll();
        long expiringSoon = docs.stream().filter(d -> d.computeExpiryStatus() == ExpiryStatus.EXPIRING_SOON).count();
        long expired = docs.stream().filter(d -> d.computeExpiryStatus() == ExpiryStatus.EXPIRED).count();

        Map<String, Long> byCompany = new LinkedHashMap<>();
        for (Object[] row : vehicleRepository.countGroupedByCompany()) {
            byCompany.put(String.valueOf(row[0]), (Long) row[1]);
        }

        Map<String, Long> byStatus = new LinkedHashMap<>();
        for (Object[] row : vehicleRepository.countGroupedByStatus()) {
            byStatus.put(String.valueOf(row[0]), (Long) row[1]);
        }

        double readiness = total == 0 ? 0.0 : ((double) (available + active) / total) * 100.0;

        return new DashboardStatsDto(
                total,
                available,
                active,
                maintenance,
                inactive,
                drivers,
                expiringSoon,
                expired,
                lowFuel,
                totalCost,
                Math.round(readiness * 10.0) / 10.0,
                byCompany,
                byStatus
        );
    }
}
