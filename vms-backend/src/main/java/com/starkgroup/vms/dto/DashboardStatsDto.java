package com.starkgroup.vms.dto;

import java.math.BigDecimal;
import java.util.Map;

public record DashboardStatsDto(
        long totalVehicles,
        long availableVehicles,
        long activeVehicles,
        long maintenanceVehicles,
        long inactiveVehicles,
        long totalDrivers,
        long expiringSoonDocuments,
        long expiredDocuments,
        long lowFuelAlerts,
        BigDecimal totalMaintenanceCost,
        double readinessPercentage,
        Map<String, Long> vehiclesByCompany,
        Map<String, Long> vehiclesByStatus
) {}
