package com.starkgroup.vms.service;

import com.starkgroup.vms.dto.MaintenanceRequestDto;
import com.starkgroup.vms.dto.MaintenanceResponseDto;
import com.starkgroup.vms.entity.MaintenanceLog;
import com.starkgroup.vms.entity.Vehicle;
import com.starkgroup.vms.exception.ResourceNotFoundException;
import com.starkgroup.vms.repository.MaintenanceLogRepository;
import com.starkgroup.vms.repository.VehicleRepository;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
public class MaintenanceService {

    private final MaintenanceLogRepository maintenanceLogRepository;
    private final VehicleRepository vehicleRepository;
    private final AuditService auditService;

    public MaintenanceService(
            MaintenanceLogRepository maintenanceLogRepository,
            VehicleRepository vehicleRepository,
            AuditService auditService) {
        this.maintenanceLogRepository = maintenanceLogRepository;
        this.vehicleRepository = vehicleRepository;
        this.auditService = auditService;
    }

    @Transactional(readOnly = true)
    public List<MaintenanceResponseDto> getMaintenanceHistory(Long vehicleId) {
        if (!vehicleRepository.existsById(vehicleId)) {
            throw new ResourceNotFoundException("Vehicle not found with id: " + vehicleId);
        }
        return maintenanceLogRepository.findByVehicleIdOrderByServiceDateDescIdDesc(vehicleId)
                .stream()
                .map(MaintenanceResponseDto::from)
                .toList();
    }

    @Transactional
    public MaintenanceResponseDto logMaintenance(Long vehicleId, MaintenanceRequestDto dto) {
        Vehicle vehicle = vehicleRepository.findById(vehicleId)
                .orElseThrow(() -> new ResourceNotFoundException("Vehicle not found with id: " + vehicleId));

        MaintenanceLog log = MaintenanceLog.builder()
                .vehicle(vehicle)
                .serviceDate(dto.serviceDate())
                .maintenanceType(dto.maintenanceType().trim())
                .serviceCost(dto.serviceCost())
                .workshopVendor(dto.workshopVendor().trim())
                .notes(dto.notes())
                .serviceOdometer(dto.serviceOdometer())
                .invoiceNumber(dto.invoiceNumber())
                .build();

        if (dto.serviceOdometer() != null && (vehicle.getOdometerKm() == null || dto.serviceOdometer() > vehicle.getOdometerKm())) {
            vehicle.setOdometerKm(dto.serviceOdometer());
            vehicleRepository.save(vehicle);
        }

        MaintenanceLog saved = maintenanceLogRepository.save(log);
        auditService.record("MAINTENANCE", saved.getId(), "CREATE", null, saved.getMaintenanceType());
        return MaintenanceResponseDto.from(saved);
    }

    @Transactional
    public void deleteMaintenanceLog(Long logId) {
        MaintenanceLog log = maintenanceLogRepository.findById(logId)
                .orElseThrow(() -> new ResourceNotFoundException("Maintenance log not found with id: " + logId));
        maintenanceLogRepository.delete(log);
        auditService.record("MAINTENANCE", logId, "DELETE", log.getMaintenanceType(), null);
    }
}
