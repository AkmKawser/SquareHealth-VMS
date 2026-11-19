package com.starkgroup.vms.dto;

import com.starkgroup.vms.enums.Role;

public record AuthResponseDto(
        String token,
        String tokenType,
        String username,
        String fullName,
        String company,
        Role role,
        long expiresInMs
) {}
