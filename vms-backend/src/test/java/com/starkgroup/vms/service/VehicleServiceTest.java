package com.starkgroup.vms.service;

import com.starkgroup.vms.dto.request.VehicleRequestDto;
import com.starkgroup.vms.dto.response.VehicleResponseDto;
import com.starkgroup.vms.entity.Vehicle;
import com.starkgroup.vms.exception.DuplicateVehicleException;
import com.starkgroup.vms.exception.ResourceNotFoundException;
import com.starkgroup.vms.repository.VehicleRepository;
import com.starkgroup.vms.service.impl.VehicleServiceImpl;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.util.List;
import java.util.Optional;

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
    private Vehicle sampleVehicle;

    @BeforeEach
    void setUp() {
        sampleDto = new VehicleRequestDto(
                "DHAKA-METRO-GA-11-2233",
                "Stark Group",
                "Ambulance",
                "Toyota",
                "HiAce",
                "AVAILABLE",
                95,
                "Md. Rafiq",
                "Emergency Response"
        );

        sampleVehicle = new Vehicle(
                sampleDto.getVehicleNumber(),
                sampleDto.getCompany(),
                sampleDto.getType(),
                sampleDto.getBrand(),
                sampleDto.getModel(),
                sampleDto.getStatus(),
                sampleDto.getFuelLevel(),
                sampleDto.getAssignedDriver(),
                sampleDto.getDepartment()
        );
        sampleVehicle.setId(1L);
    }

    @Test
    @DisplayName("Should successfully create a vehicle when vehicleNumber is unique")
    void shouldCreateVehicleWhenUnique() {
        when(vehicleRepository.existsByVehicleNumber(sampleDto.getVehicleNumber())).thenReturn(false);
        when(vehicleRepository.save(any(Vehicle.class))).thenReturn(sampleVehicle);

        VehicleResponseDto response = vehicleService.createVehicle(sampleDto);

        assertNotNull(response);
        assertEquals(1L, response.getId());
        assertEquals("DHAKA-METRO-GA-11-2233", response.getVehicleNumber());
        assertEquals("Stark Group", response.getCompany());
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

    @Test
    @DisplayName("Should return all vehicles")
    void shouldReturnAllVehicles() {
        when(vehicleRepository.findAll()).thenReturn(List.of(sampleVehicle));

        List<VehicleResponseDto> result = vehicleService.getAllVehicles();

        assertNotNull(result);
        assertEquals(1, result.size());
        assertEquals("DHAKA-METRO-GA-11-2233", result.get(0).getVehicleNumber());
    }

    @Test
    @DisplayName("Should get vehicle by ID when exists")
    void shouldGetVehicleById() {
        when(vehicleRepository.findById(1L)).thenReturn(Optional.of(sampleVehicle));

        VehicleResponseDto response = vehicleService.getVehicleById(1L);

        assertNotNull(response);
        assertEquals(1L, response.getId());
    }

    @Test
    @DisplayName("Should throw ResourceNotFoundException when vehicle does not exist")
    void shouldThrowWhenVehicleNotFound() {
        when(vehicleRepository.findById(99L)).thenReturn(Optional.empty());

        assertThrows(ResourceNotFoundException.class, () -> vehicleService.getVehicleById(99L));
    }

    @Test
    @DisplayName("Should update vehicle details successfully")
    void shouldUpdateVehicle() {
        when(vehicleRepository.findById(1L)).thenReturn(Optional.of(sampleVehicle));
        when(vehicleRepository.save(any(Vehicle.class))).thenReturn(sampleVehicle);

        VehicleRequestDto updateDto = new VehicleRequestDto(
                "DHAKA-METRO-GA-11-2233",
                "Stark Group Updated",
                "Ambulance",
                "Toyota",
                "HiAce",
                "ON_TRIP"
        );

        VehicleResponseDto result = vehicleService.updateVehicle(1L, updateDto);

        assertNotNull(result);
        assertEquals("Stark Group Updated", result.getCompany());
    }

    @Test
    @DisplayName("Should delete vehicle by ID")
    void shouldDeleteVehicle() {
        when(vehicleRepository.existsById(1L)).thenReturn(true);
        doNothing().when(vehicleRepository).deleteById(1L);

        assertDoesNotThrow(() -> vehicleService.deleteVehicle(1L));
        verify(vehicleRepository, times(1)).deleteById(1L);
    }
}
