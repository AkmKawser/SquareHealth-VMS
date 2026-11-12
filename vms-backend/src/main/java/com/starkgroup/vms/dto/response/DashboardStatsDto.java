package com.starkgroup.vms.dto.response;

public class DashboardStatsDto {

    private long totalVehicles;
    private long activeVehicles;
    private long maintenanceVehicles;
    private long availableVehicles;
    private double fleetEfficiency;
    private long fuelAlerts;

    public DashboardStatsDto() {
    }

    public DashboardStatsDto(long totalVehicles, long activeVehicles, long maintenanceVehicles,
                             long availableVehicles, double fleetEfficiency, long fuelAlerts) {
        this.totalVehicles = totalVehicles;
        this.activeVehicles = activeVehicles;
        this.maintenanceVehicles = maintenanceVehicles;
        this.availableVehicles = availableVehicles;
        this.fleetEfficiency = fleetEfficiency;
        this.fuelAlerts = fuelAlerts;
    }

    public long getTotalVehicles() {
        return totalVehicles;
    }

    public void setTotalVehicles(long totalVehicles) {
        this.totalVehicles = totalVehicles;
    }

    public long getActiveVehicles() {
        return activeVehicles;
    }

    public void setActiveVehicles(long activeVehicles) {
        this.activeVehicles = activeVehicles;
    }

    public long getMaintenanceVehicles() {
        return maintenanceVehicles;
    }

    public void setMaintenanceVehicles(long maintenanceVehicles) {
        this.maintenanceVehicles = maintenanceVehicles;
    }

    public long getAvailableVehicles() {
        return availableVehicles;
    }

    public void setAvailableVehicles(long availableVehicles) {
        this.availableVehicles = availableVehicles;
    }

    public double getFleetEfficiency() {
        return fleetEfficiency;
    }

    public void setFleetEfficiency(double fleetEfficiency) {
        this.fleetEfficiency = fleetEfficiency;
    }

    public long getFuelAlerts() {
        return fuelAlerts;
    }

    public void setFuelAlerts(long fuelAlerts) {
        this.fuelAlerts = fuelAlerts;
    }
}
