package com.starkgroup.vms.entity;

import jakarta.persistence.*;
import java.time.LocalDateTime;

@Entity
@Table(name = "vehicles", uniqueConstraints = {
    @UniqueConstraint(columnNames = "vehicle_number")
})
public class Vehicle {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "vehicle_number", nullable = false, unique = true, length = 50)
    private String vehicleNumber;

    @Column(name = "company", nullable = false, length = 100)
    private String company;

    @Column(name = "type", nullable = false, length = 50)
    private String type;

    @Column(name = "brand", nullable = false, length = 50)
    private String brand;

    @Column(name = "model", nullable = false, length = 100)
    private String model;

    @Column(name = "status", nullable = false, length = 30)
    private String status;

    @Column(name = "fuel_level")
    private Integer fuelLevel = 100;

    @Column(name = "fuel_capacity")
    private Double fuelCapacity = 65.0;

    @Column(name = "assigned_driver", length = 100)
    private String assignedDriver;

    @Column(name = "department", length = 100)
    private String department = "General Logistics";

    @Column(name = "created_at")
    private LocalDateTime createdAt = LocalDateTime.now();

    @Column(name = "updated_at")
    private LocalDateTime updatedAt = LocalDateTime.now();

    public Vehicle() {
    }

    public Vehicle(String vehicleNumber, String company, String type, String brand, String model, String status) {
        this.vehicleNumber = vehicleNumber;
        this.company = company;
        this.type = type;
        this.brand = brand;
        this.model = model;
        this.status = status;
        this.fuelLevel = 100;
        this.fuelCapacity = 65.0;
        this.createdAt = LocalDateTime.now();
        this.updatedAt = LocalDateTime.now();
    }

    public Vehicle(String vehicleNumber, String company, String type, String brand, String model, String status,
                   Integer fuelLevel, String assignedDriver, String department) {
        this.vehicleNumber = vehicleNumber;
        this.company = company;
        this.type = type;
        this.brand = brand;
        this.model = model;
        this.status = status;
        this.fuelLevel = fuelLevel != null ? fuelLevel : 100;
        this.assignedDriver = assignedDriver;
        this.department = department != null ? department : "General Logistics";
        this.createdAt = LocalDateTime.now();
        this.updatedAt = LocalDateTime.now();
    }

    @PreUpdate
    public void onUpdate() {
        this.updatedAt = LocalDateTime.now();
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

    public Double getFuelCapacity() {
        return fuelCapacity;
    }

    public void setFuelCapacity(Double fuelCapacity) {
        this.fuelCapacity = fuelCapacity;
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

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }

    public LocalDateTime getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(LocalDateTime updatedAt) {
        this.updatedAt = updatedAt;
    }
}
