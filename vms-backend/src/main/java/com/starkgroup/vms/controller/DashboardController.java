package com.starkgroup.vms.controller;

import com.starkgroup.vms.dto.response.DashboardStatsDto;
import com.starkgroup.vms.dto.response.VehicleResponseDto;
import com.starkgroup.vms.service.VehicleService;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
@RequestMapping("/api/v1/dashboard")
@CrossOrigin(origins = "*")
public class DashboardController {

    private final VehicleService vehicleService;

    public DashboardController(VehicleService vehicleService) {
        this.vehicleService = vehicleService;
    }

    @GetMapping("/stats")
    public ResponseEntity<DashboardStatsDto> getDashboardStats() {
        List<VehicleResponseDto> vehicles = vehicleService.getAllVehicles();

        long total = vehicles.size();
        long active = vehicles.stream().filter(v -> "Active".equalsIgnoreCase(v.getStatus()) || "ON_TRIP".equalsIgnoreCase(v.getStatus())).count();
        long maintenance = vehicles.stream().filter(v -> "Maintenance".equalsIgnoreCase(v.getStatus()) || "MAINTENANCE".equalsIgnoreCase(v.getStatus())).count();
        long available = vehicles.stream().filter(v -> "Available".equalsIgnoreCase(v.getStatus()) || "AVAILABLE".equalsIgnoreCase(v.getStatus())).count();
        long lowFuel = vehicles.stream().filter(v -> v.getFuelLevel() != null && v.getFuelLevel() < 25).count();
        double efficiency = 12.4; // Average km/L standard

        DashboardStatsDto stats = new DashboardStatsDto(total, active, maintenance, available, efficiency, lowFuel);
        return ResponseEntity.ok(stats);
    }
}

