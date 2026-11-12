package com.starkgroup.vms.dto.response;

public class VehicleResponseDto {

    private Long id;
    private String vehicleNumber;
    private String company;
    private String type;
    private String brand;
    private String model;
    private String status;
    private Integer fuelLevel;
    private String assignedDriver;
    private String department;

    public VehicleResponseDto() {
    }

    public VehicleResponseDto(Long id, String vehicleNumber, String company, String type, String brand, String model, String status) {
        this.id = id;
        this.vehicleNumber = vehicleNumber;
        this.company = company;
        this.type = type;
        this.brand = brand;
        this.model = model;
        this.status = status;
        this.fuelLevel = 100;
        this.assignedDriver = "Unassigned";
        this.department = "General Logistics";
    }

    public VehicleResponseDto(Long id, String vehicleNumber, String company, String type, String brand, String model,
                              String status, Integer fuelLevel, String assignedDriver, String department) {
        this.id = id;
        this.vehicleNumber = vehicleNumber;
        this.company = company;
        this.type = type;
        this.brand = brand;
        this.model = model;
        this.status = status;
        this.fuelLevel = fuelLevel;
        this.assignedDriver = assignedDriver;
        this.department = department;
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getVehicleNumber() {
        return vehicleNumber;
    }

    public void setVehicleNumber(String vehicleNumber) {
        this.vehicleNumber = vehicleNumber;
    }

    public String getCompany() {
        return company;
    }

    public void setCompany(String company) {
        this.company = company;
    }

    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
    }

    public String getBrand() {
        return brand;
    }

    public void setBrand(String brand) {
        this.brand = brand;
    }

    public String getModel() {
        return model;
    }

    public void setModel(String model) {
        this.model = model;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public Integer getFuelLevel() {
        return fuelLevel;
    }

    public void setFuelLevel(Integer fuelLevel) {
        this.fuelLevel = fuelLevel;
    }

    public String getAssignedDriver() {
        return assignedDriver;
    }

    public void setAssignedDriver(String assignedDriver) {
        this.assignedDriver = assignedDriver;
    }

    public String getDepartment() {
        return department;
    }

    public void setDepartment(String department) {
        this.department = department;
    }
}
