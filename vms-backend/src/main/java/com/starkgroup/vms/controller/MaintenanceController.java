package com.starkgroup.vms.controller;

import com.starkgroup.vms.dto.MaintenanceRequestDto;
import com.starkgroup.vms.dto.MaintenanceResponseDto;
import com.starkgroup.vms.service.MaintenanceService;
import jakarta.validation.Valid;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/v1")
public class MaintenanceController {

    private final MaintenanceService maintenanceService;

    public MaintenanceController(MaintenanceService maintenanceService) {
        this.maintenanceService = maintenanceService;
    }

    @GetMapping("/vehicles/{vehicleId}/maintenance")
    public ResponseEntity<List<MaintenanceResponseDto>> getHistory(@PathVariable Long vehicleId) {
        return ResponseEntity.ok(maintenanceService.getMaintenanceHistory(vehicleId));
    }

    @PostMapping("/vehicles/{vehicleId}/maintenance")
    @PreAuthorize("hasAnyRole('ADMIN', 'FLEET_MANAGER', 'DISPATCHER')")
    public ResponseEntity<MaintenanceResponseDto> logMaintenance(
            @PathVariable Long vehicleId,
            @Valid @RequestBody MaintenanceRequestDto dto) {
        return ResponseEntity.status(HttpStatus.CREATED).body(maintenanceService.logMaintenance(vehicleId, dto));
    }

    @DeleteMapping("/maintenance/{logId}")
    @PreAuthorize("hasAnyRole('ADMIN', 'FLEET_MANAGER')")
    public ResponseEntity<Void> deleteMaintenance(@PathVariable Long logId) {
        maintenanceService.deleteMaintenanceLog(logId);
        return ResponseEntity.noContent().build();
    }
}
