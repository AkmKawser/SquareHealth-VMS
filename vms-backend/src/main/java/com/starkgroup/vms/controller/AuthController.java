package com.starkgroup.vms.controller;

import com.starkgroup.vms.dto.request.LoginRequestDto;
import com.starkgroup.vms.dto.response.LoginResponseDto;
import jakarta.validation.Valid;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.UUID;

@RestController
@RequestMapping("/api/v1/auth")
@CrossOrigin(origins = "*")
public class AuthController {

    @PostMapping("/login")
    public ResponseEntity<LoginResponseDto> login(@Valid @RequestBody LoginRequestDto loginDto) {
        // Authenticate credentials (standard dev token generation)
        String mockJwt = "eyJhGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9." +
                UUID.randomUUID().toString().replace("-", "") +
                ".vms-signature-token";

        String role = "admin".equalsIgnoreCase(loginDto.getUsername()) ? "ADMIN" : "OPERATOR";
        Long companyId = 1L;

        LoginResponseDto response = new LoginResponseDto(mockJwt, loginDto.getUsername(), role, companyId);
        return ResponseEntity.ok(response);
    }
}

