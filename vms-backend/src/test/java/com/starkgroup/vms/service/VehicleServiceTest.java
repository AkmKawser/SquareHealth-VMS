package com.starkgroup.vms.service;

import com.starkgroup.vms.dto.request.VehicleRequestDto;
import com.starkgroup.vms.dto.response.VehicleResponseDto;
import com.starkgroup.vms.entity.Vehicle;
import com.starkgroup.vms.exception.DuplicateVehicleException;
import com.starkgroup.vms.repository.VehicleRepository;
import com.starkgroup.vms.service.impl.VehicleServiceImpl;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
class VehicleServiceTest {

    @Mock
    private VehicleRepository vehicleRepository;

    @InjectMocks
    private VehicleServiceImpl vehicleService;

    private VehicleRequestDto sampleDto;

    @BeforeEach
    void setUp() {
        sampleDto = new VehicleRequestDto(
                "DHAKA-METRO-GA-11-2233",
                "Square Health",
                "Ambulance",
                "Toyota",
                "HiAce",
                "ACTIVE"
        );
    }

    @Test
    @DisplayName("Should successfully create a vehicle when vehicleNumber is unique")
    void shouldCreateVehicleWhenUnique() {
        when(vehicleRepository.existsByVehicleNumber(sampleDto.getVehicleNumber())).thenReturn(false);

        Vehicle saved = new Vehicle(
                sampleDto.getVehicleNumber(),
                sampleDto.getCompany(),
                sampleDto.getType(),
                sampleDto.getBrand(),
                sampleDto.getModel(),
                sampleDto.getStatus()
        );
        saved.setId(1L);

        when(vehicleRepository.save(any(Vehicle.class))).thenReturn(saved);

        VehicleResponseDto response = vehicleService.createVehicle(sampleDto);

        assertNotNull(response);
        assertEquals(1L, response.getId());
        assertEquals("DHAKA-METRO-GA-11-2233", response.getVehicleNumber());
        verify(vehicleRepository, times(1)).save(any(Vehicle.class));
    }

    @Test
    @DisplayName("Should throw DuplicateVehicleException when vehicleNumber already exists")
    void shouldThrowExceptionWhenDuplicateVehicleNumber() {
        when(vehicleRepository.existsByVehicleNumber(sampleDto.getVehicleNumber())).thenReturn(true);

        DuplicateVehicleException exception = assertThrows(
                DuplicateVehicleException.class,
                () -> vehicleService.createVehicle(sampleDto)
        );

        assertTrue(exception.getMessage().contains("already exists"));
        verify(vehicleRepository, never()).save(any(Vehicle.class));
    }
}

