package com.starkgroup.vms.controller;

import com.starkgroup.vms.dto.request.VehicleRequestDto;
import com.starkgroup.vms.dto.response.VehicleResponseDto;
import com.starkgroup.vms.service.VehicleService;
import jakarta.validation.Valid;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/v1/vehicles")
@CrossOrigin(origins = "*")
public class VehicleController {

    private final VehicleService vehicleService;

    public VehicleController(VehicleService vehicleService) {
        this.vehicleService = vehicleService;
    }

    @GetMapping
    public ResponseEntity<List<VehicleResponseDto>> getAllVehicles(
            @RequestParam(required = false) String search,
            @RequestParam(required = false) String status) {
        if (search != null || status != null) {
            return ResponseEntity.ok(vehicleService.searchVehicles(search, status));
        }
        return ResponseEntity.ok(vehicleService.getAllVehicles());
    }

    @GetMapping("/{id}")
    public ResponseEntity<VehicleResponseDto> getVehicleById(@PathVariable Long id) {
        return ResponseEntity.ok(vehicleService.getVehicleById(id));
    }

    @PostMapping
    public ResponseEntity<VehicleResponseDto> createVehicle(@Valid @RequestBody VehicleRequestDto requestDto) {
        VehicleResponseDto created = vehicleService.createVehicle(requestDto);
        return new ResponseEntity<>(created, HttpStatus.CREATED);
    }

    @PutMapping("/{id}")
    public ResponseEntity<VehicleResponseDto> updateVehicle(@PathVariable Long id,
                                                            @Valid @RequestBody VehicleRequestDto requestDto) {
        VehicleResponseDto updated = vehicleService.updateVehicle(id, requestDto);
        return ResponseEntity.ok(updated);
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deleteVehicle(@PathVariable Long id) {
        vehicleService.deleteVehicle(id);
        return ResponseEntity.noContent().build();
    }
}
