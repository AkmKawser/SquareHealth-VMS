package com.starkgroup.vms.dto.request;

import jakarta.validation.constraints.NotBlank;

public class VehicleRequestDto {

    @NotBlank(message = "Vehicle number is required")
    private String vehicleNumber;

    @NotBlank(message = "Company is required")
    private String company;

    @NotBlank(message = "Type is required")
    private String type;

    @NotBlank(message = "Brand is required")
    private String brand;

    @NotBlank(message = "Model is required")
    private String model;

    @NotBlank(message = "Status is required")
    private String status;

    public VehicleRequestDto() {
    }

    public VehicleRequestDto(String vehicleNumber, String company, String type, String brand, String model, String status) {
        this.vehicleNumber = vehicleNumber;
        this.company = company;
        this.type = type;
        this.brand = brand;
        this.model = model;
        this.status = status;
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
}

