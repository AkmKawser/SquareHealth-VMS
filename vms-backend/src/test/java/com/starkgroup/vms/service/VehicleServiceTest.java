package com.starkgroup.vms.service;

import com.starkgroup.vms.dto.VehicleRequestDto;
import com.starkgroup.vms.dto.VehicleResponseDto;
import com.starkgroup.vms.entity.Vehicle;
import com.starkgroup.vms.enums.FuelType;
import com.starkgroup.vms.enums.VehicleStatus;
import com.starkgroup.vms.enums.VehicleType;
import com.starkgroup.vms.exception.DuplicateResourceException;
import com.starkgroup.vms.repository.DriverRepository;
import com.starkgroup.vms.repository.VehicleDocumentRepository;
import com.starkgroup.vms.repository.VehicleRepository;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.math.BigDecimal;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
class VehicleServiceTest {

    @Mock
    private VehicleRepository vehicleRepository;
    @Mock
    private DriverRepository driverRepository;
    @Mock
    private VehicleDocumentRepository documentRepository;
    @Mock
    private AuditService auditService;

    private VehicleService vehicleService;

    @BeforeEach
    void setUp() {
        vehicleService = new VehicleService(vehicleRepository, driverRepository, documentRepository, auditService);
    }

    @Test
    void createVehicle_throwsDuplicateResourceException_whenPlateExists() {
        VehicleRequestDto dto = new VehicleRequestDto(
                "DHAKA-METRO-GA-11-2233", "Stark Group", VehicleType.AMBULANCE,
                "Toyota", "HiAce", 2023, "White", 6, FuelType.DIESEL,
                VehicleStatus.AVAILABLE, new BigDecimal("3500"), 90, 12000,
                "Emergency", null, null, null
        );

        when(vehicleRepository.existsByVehicleNumberIgnoreCase("DHAKA-METRO-GA-11-2233")).thenReturn(true);

        DuplicateResourceException ex = assertThrows(
                DuplicateResourceException.class,
                () -> vehicleService.createVehicle(dto)
        );
        assertTrue(ex.getMessage().contains("DHAKA-METRO-GA-11-2233"));
        verify(vehicleRepository, never()).save(any());
    }

    @Test
    void createVehicle_persistsAndNormalizesPlate_whenUnique() {
        VehicleRequestDto dto = new VehicleRequestDto(
                "dhaka-metro-ga-99-0001", "Stark Group", VehicleType.CAR,
                "Toyota", "Corolla", 2023, "Silver", 5, FuelType.HYBRID,
                VehicleStatus.AVAILABLE, new BigDecimal("2500"), 100, 0,
                "Corporate", null, "Rahim", "+8801711000001"
        );

        when(vehicleRepository.existsByVehicleNumberIgnoreCase("DHAKA-METRO-GA-99-0001")).thenReturn(false);
        when(vehicleRepository.save(any(Vehicle.class))).thenAnswer(inv -> {
            Vehicle v = inv.getArgument(0);
            v.setId(42L);
            return v;
        });

        VehicleResponseDto created = vehicleService.createVehicle(dto);

        assertEquals(42L, created.id());
        assertEquals("DHAKA-METRO-GA-99-0001", created.vehicleNumber());
        verify(auditService).record("VEHICLE", 42L, "CREATE", null, "DHAKA-METRO-GA-99-0001");
    }
}
