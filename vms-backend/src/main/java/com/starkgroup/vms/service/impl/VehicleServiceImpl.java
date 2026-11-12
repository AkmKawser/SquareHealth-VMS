package com.starkgroup.vms.service.impl;

import com.starkgroup.vms.dto.request.VehicleRequestDto;
import com.starkgroup.vms.dto.response.VehicleResponseDto;
import com.starkgroup.vms.entity.Vehicle;
import com.starkgroup.vms.exception.DuplicateVehicleException;
import com.starkgroup.vms.exception.ResourceNotFoundException;
import com.starkgroup.vms.repository.VehicleRepository;
import com.starkgroup.vms.service.VehicleService;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.stream.Collectors;

@Service
@Transactional
public class VehicleServiceImpl implements VehicleService {

    private final VehicleRepository vehicleRepository;

    public VehicleServiceImpl(VehicleRepository vehicleRepository) {
        this.vehicleRepository = vehicleRepository;
    }

    @Override
    @Transactional(readOnly = true)
    public List<VehicleResponseDto> getAllVehicles() {
        return vehicleRepository.findAll().stream()
                .map(this::mapToResponseDto)
                .collect(Collectors.toList());
    }

    @Override
    @Transactional(readOnly = true)
    public List<VehicleResponseDto> searchVehicles(String search, String status) {
        return vehicleRepository.findAll().stream()
                .filter(v -> {
                    boolean matchStatus = (status == null || status.isBlank() || status.equalsIgnoreCase("ALL") || v.getStatus().equalsIgnoreCase(status));
                    boolean matchSearch = (search == null || search.isBlank() ||
                            v.getVehicleNumber().toLowerCase().contains(search.toLowerCase()) ||
                            v.getModel().toLowerCase().contains(search.toLowerCase()) ||
                            (v.getAssignedDriver() != null && v.getAssignedDriver().toLowerCase().contains(search.toLowerCase())) ||
                            v.getCompany().toLowerCase().contains(search.toLowerCase()) ||
                            v.getDepartment().toLowerCase().contains(search.toLowerCase()));
                    return matchStatus && matchSearch;
                })
                .map(this::mapToResponseDto)
                .collect(Collectors.toList());
    }

    @Override
    @Transactional(readOnly = true)
    public VehicleResponseDto getVehicleById(Long id) {
        Vehicle vehicle = vehicleRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Vehicle not found with id: " + id));
        return mapToResponseDto(vehicle);
    }

    @Override
    public VehicleResponseDto createVehicle(VehicleRequestDto requestDto) {
        if (vehicleRepository.existsByVehicleNumber(requestDto.getVehicleNumber())) {
            throw new DuplicateVehicleException("Vehicle with number '" + requestDto.getVehicleNumber() + "' already exists.");
        }

        Vehicle vehicle = new Vehicle(
                requestDto.getVehicleNumber(),
                requestDto.getCompany(),
                requestDto.getType(),
                requestDto.getBrand(),
                requestDto.getModel(),
                requestDto.getStatus(),
                requestDto.getFuelLevel(),
                requestDto.getAssignedDriver(),
                requestDto.getDepartment()
        );

        Vehicle saved = vehicleRepository.save(vehicle);
        return mapToResponseDto(saved);
    }

    @Override
    public VehicleResponseDto updateVehicle(Long id, VehicleRequestDto requestDto) {
        Vehicle vehicle = vehicleRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Vehicle not found with id: " + id));

        // If vehicle number is changing, verify the new number is not taken
        if (!vehicle.getVehicleNumber().equalsIgnoreCase(requestDto.getVehicleNumber())
                && vehicleRepository.existsByVehicleNumber(requestDto.getVehicleNumber())) {
            throw new DuplicateVehicleException("Vehicle with number '" + requestDto.getVehicleNumber() + "' already exists.");
        }

        vehicle.setVehicleNumber(requestDto.getVehicleNumber());
        vehicle.setCompany(requestDto.getCompany());
        vehicle.setType(requestDto.getType());
        vehicle.setBrand(requestDto.getBrand());
        vehicle.setModel(requestDto.getModel());
        vehicle.setStatus(requestDto.getStatus());
        if (requestDto.getFuelLevel() != null) vehicle.setFuelLevel(requestDto.getFuelLevel());
        if (requestDto.getAssignedDriver() != null) vehicle.setAssignedDriver(requestDto.getAssignedDriver());
        if (requestDto.getDepartment() != null) vehicle.setDepartment(requestDto.getDepartment());

        Vehicle updated = vehicleRepository.save(vehicle);
        return mapToResponseDto(updated);
    }

    @Override
    public void deleteVehicle(Long id) {
        if (!vehicleRepository.existsById(id)) {
            throw new ResourceNotFoundException("Vehicle not found with id: " + id);
        }
        vehicleRepository.deleteById(id);
    }

    private VehicleResponseDto mapToResponseDto(Vehicle vehicle) {
        return new VehicleResponseDto(
                vehicle.getId(),
                vehicle.getVehicleNumber(),
                vehicle.getCompany(),
                vehicle.getType(),
                vehicle.getBrand(),
                vehicle.getModel(),
                vehicle.getStatus(),
                vehicle.getFuelLevel(),
                vehicle.getAssignedDriver(),
                vehicle.getDepartment()
        );
    }
}
