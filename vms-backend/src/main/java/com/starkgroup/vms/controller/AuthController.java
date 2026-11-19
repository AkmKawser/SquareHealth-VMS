package com.starkgroup.vms.controller;

import com.starkgroup.vms.dto.AuthRequestDto;
import com.starkgroup.vms.dto.AuthResponseDto;
import com.starkgroup.vms.entity.User;
import com.starkgroup.vms.repository.UserRepository;
import com.starkgroup.vms.security.JwtService;
import jakarta.validation.Valid;
import org.springframework.http.ResponseEntity;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.web.bind.annotation.*;

import java.util.Map;

@RestController
@RequestMapping("/api/v1/auth")
public class AuthController {

    private final AuthenticationManager authenticationManager;
    private final UserDetailsService userDetailsService;
    private final UserRepository userRepository;
    private final JwtService jwtService;

    public AuthController(
            AuthenticationManager authenticationManager,
            UserDetailsService userDetailsService,
            UserRepository userRepository,
            JwtService jwtService) {
        this.authenticationManager = authenticationManager;
        this.userDetailsService = userDetailsService;
        this.userRepository = userRepository;
        this.jwtService = jwtService;
    }

    @PostMapping("/login")
    public ResponseEntity<AuthResponseDto> login(@Valid @RequestBody AuthRequestDto request) {
        authenticationManager.authenticate(
                new UsernamePasswordAuthenticationToken(request.username(), request.password()));

        User user = userRepository.findByUsernameIgnoreCase(request.username()).orElseThrow();
        UserDetails userDetails = userDetailsService.loadUserByUsername(user.getUsername());
        String token = jwtService.generateToken(userDetails, Map.of(
                "role", user.getRole().name(),
                "company", user.getCompany()
        ));

        return ResponseEntity.ok(new AuthResponseDto(
                token,
                "Bearer",
                user.getUsername(),
                user.getFullName(),
                user.getCompany(),
                user.getRole(),
                jwtService.getExpirationMs()
        ));
    }
}
