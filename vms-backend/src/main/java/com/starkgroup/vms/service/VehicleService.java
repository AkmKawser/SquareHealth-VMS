package com.starkgroup.vms.service;

import com.starkgroup.vms.dto.request.VehicleRequestDto;
import com.starkgroup.vms.dto.response.VehicleResponseDto;

import java.util.List;

public interface VehicleService {

    List<VehicleResponseDto> getAllVehicles();

    VehicleResponseDto getVehicleById(Long id);

    VehicleResponseDto createVehicle(VehicleRequestDto requestDto);

    VehicleResponseDto updateVehicle(Long id, VehicleRequestDto requestDto);

    void deleteVehicle(Long id);
}

