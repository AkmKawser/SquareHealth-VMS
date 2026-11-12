package com.starkgroup.vms.controller;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.starkgroup.vms.dto.request.VehicleRequestDto;
import com.starkgroup.vms.dto.response.VehicleResponseDto;
import com.starkgroup.vms.exception.DuplicateVehicleException;
import com.starkgroup.vms.service.VehicleService;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.WebMvcTest;
import org.springframework.boot.test.mock.mockito.MockBean;
import org.springframework.http.MediaType;
import org.springframework.test.web.servlet.MockMvc;

import java.util.List;

import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.when;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.*;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;

@WebMvcTest(VehicleController.class)
class VehicleControllerTest {

    @Autowired
    private MockMvc mockMvc;

    @Autowired
    private ObjectMapper objectMapper;

    @MockBean
    private VehicleService vehicleService;

    @Test
    @DisplayName("GET /api/v1/vehicles returns 200 and list")
    void shouldReturnAllVehicles() throws Exception {
        VehicleResponseDto dto = new VehicleResponseDto(
                1L, "DHA-GA-11-2045", "Stark Group", "Ambulance", "Toyota", "HiAce", "AVAILABLE"
        );
        when(vehicleService.getAllVehicles()).thenReturn(List.of(dto));

        mockMvc.perform(get("/api/v1/vehicles"))
                .andExpect(status().isOk())
                .andExpect(content().contentType(MediaType.APPLICATION_JSON))
                .andExpect(jsonPath("$[0].vehicleNumber").value("DHA-GA-11-2045"));
    }

    @Test
    @DisplayName("POST /api/v1/vehicles returns 201 Created on valid vehicle")
    void shouldCreateVehicle() throws Exception {
        VehicleRequestDto request = new VehicleRequestDto(
                "DHA-GA-11-2045", "Stark Group", "Ambulance", "Toyota", "HiAce", "AVAILABLE"
        );
        VehicleResponseDto response = new VehicleResponseDto(
                1L, "DHA-GA-11-2045", "Stark Group", "Ambulance", "Toyota", "HiAce", "AVAILABLE"
        );
        when(vehicleService.createVehicle(any(VehicleRequestDto.class))).thenReturn(response);

        mockMvc.perform(post("/api/v1/vehicles")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(request)))
                .andExpect(status().isCreated())
                .andExpect(jsonPath("$.id").value(1L))
                .andExpect(jsonPath("$.vehicleNumber").value("DHA-GA-11-2045"));
    }

    @Test
    @DisplayName("POST /api/v1/vehicles returns 409 Conflict when duplicate license plate")
    void shouldReturn409WhenDuplicate() throws Exception {
        VehicleRequestDto request = new VehicleRequestDto(
                "DHA-GA-11-2045", "Stark Group", "Ambulance", "Toyota", "HiAce", "AVAILABLE"
        );
        when(vehicleService.createVehicle(any(VehicleRequestDto.class)))
                .thenThrow(new DuplicateVehicleException("Vehicle with number 'DHA-GA-11-2045' already exists."));

        mockMvc.perform(post("/api/v1/vehicles")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(request)))
                .andExpect(status().isConflict())
                .andExpect(jsonPath("$.status").value(409))
                .andExpect(jsonPath("$.message").value("Vehicle with number 'DHA-GA-11-2045' already exists."));
    }

    @Test
    @DisplayName("POST /api/v1/vehicles returns 400 Bad Request on blank field")
    void shouldReturn400WhenInvalid() throws Exception {
        VehicleRequestDto invalidRequest = new VehicleRequestDto(
                "", "Stark Group", "Ambulance", "Toyota", "HiAce", "AVAILABLE"
        );

        mockMvc.perform(post("/api/v1/vehicles")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(invalidRequest)))
                .andExpect(status().isBadRequest());
    }
}

