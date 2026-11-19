package com.starkgroup.vms.controller;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.starkgroup.vms.dto.VehicleRequestDto;
import com.starkgroup.vms.enums.FuelType;
import com.starkgroup.vms.enums.VehicleStatus;
import com.starkgroup.vms.enums.VehicleType;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.http.MediaType;
import org.springframework.security.test.context.support.WithMockUser;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.test.web.servlet.MockMvc;

import java.math.BigDecimal;

import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;

@SpringBootTest
@AutoConfigureMockMvc
@ActiveProfiles("test")
class VehicleControllerTest {

    @Autowired
    private MockMvc mockMvc;

    @Autowired
    private ObjectMapper objectMapper;

    @Test
    @WithMockUser(username = "admin", roles = "ADMIN")
    void getVehicles_returnsPagedResponseWithSeededData() throws Exception {
        mockMvc.perform(get("/api/v1/vehicles?page=0&size=5"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.content").isArray())
                .andExpect(jsonPath("$.totalElements").value(20))
                .andExpect(jsonPath("$.hasNext").value(true));
    }

    @Test
    @WithMockUser(username = "admin", roles = "ADMIN")
    void createVehicle_returns409Conflict_whenDuplicatePlateSubmitted() throws Exception {
        VehicleRequestDto duplicateDto = new VehicleRequestDto(
                "DHAKA-METRO-GA-11-2233", "Stark Group", VehicleType.AMBULANCE,
                "Toyota", "HiAce", 2023, "White", 6, FuelType.DIESEL,
                VehicleStatus.AVAILABLE, new BigDecimal("3500"), 80, 10000,
                "Emergency", null, null, null
        );

        mockMvc.perform(post("/api/v1/vehicles")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(duplicateDto)))
                .andExpect(status().isConflict())
                .andExpect(jsonPath("$.status").value(409));
    }
}
