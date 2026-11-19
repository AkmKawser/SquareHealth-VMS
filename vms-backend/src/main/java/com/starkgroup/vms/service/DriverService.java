package com.starkgroup.vms.service;

import com.starkgroup.vms.dto.DriverRequestDto;
import com.starkgroup.vms.dto.DriverResponseDto;
import com.starkgroup.vms.dto.PagedResponse;
import com.starkgroup.vms.entity.Driver;
import com.starkgroup.vms.exception.DuplicateResourceException;
import com.starkgroup.vms.exception.ResourceNotFoundException;
import com.starkgroup.vms.repository.DriverRepository;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
public class DriverService {

    private final DriverRepository driverRepository;
    private final AuditService auditService;

    public DriverService(DriverRepository driverRepository, AuditService auditService) {
        this.driverRepository = driverRepository;
        this.auditService = auditService;
    }

    @Transactional(readOnly = true)
    public PagedResponse<DriverResponseDto> getDrivers(int page, int size, String search) {
        PageRequest pageable = PageRequest.of(Math.max(page, 0), Math.min(Math.max(size, 1), 100), Sort.by("fullName").ascending());
        Page<DriverResponseDto> result = driverRepository.searchDrivers(search, pageable).map(DriverResponseDto::from);
        return PagedResponse.from(result);
    }

    @Transactional(readOnly = true)
    public DriverResponseDto getDriverById(Long id) {
        Driver driver = driverRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Driver not found with id: " + id));
        return DriverResponseDto.from(driver);
    }

    @Transactional
    public DriverResponseDto createDriver(DriverRequestDto dto) {
        String license = dto.licenseNumber().trim().toUpperCase();
        if (driverRepository.existsByLicenseNumberIgnoreCase(license)) {
            throw new DuplicateResourceException("Driver with license '" + license + "' already exists.");
        }
        Driver driver = Driver.builder()
                .nationalId(dto.nationalId())
                .fullName(dto.fullName().trim())
                .licenseNumber(license)
                .licenseExpiryDate(dto.licenseExpiryDate())
                .phone(dto.phone().trim())
                .emergencyContact(dto.emergencyContact())
                .medicalCleared(dto.medicalCleared() != null ? dto.medicalCleared() : true)
                .active(dto.active() != null ? dto.active() : true)
                .build();
        Driver saved = driverRepository.save(driver);
        auditService.record("DRIVER", saved.getId(), "CREATE", null, saved.getFullName());
        return DriverResponseDto.from(saved);
    }

    @Transactional
    public DriverResponseDto updateDriver(Long id, DriverRequestDto dto) {
        Driver driver = driverRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Driver not found with id: " + id));
        String license = dto.licenseNumber().trim().toUpperCase();
        if (driverRepository.existsByLicenseNumberIgnoreCaseAndIdNot(license, id)) {
            throw new DuplicateResourceException("Driver with license '" + license + "' already exists.");
        }
        driver.setNationalId(dto.nationalId());
        driver.setFullName(dto.fullName().trim());
        driver.setLicenseNumber(license);
        driver.setLicenseExpiryDate(dto.licenseExpiryDate());
        driver.setPhone(dto.phone().trim());
        driver.setEmergencyContact(dto.emergencyContact());
        if (dto.medicalCleared() != null) driver.setMedicalCleared(dto.medicalCleared());
        if (dto.active() != null) driver.setActive(dto.active());
        Driver saved = driverRepository.save(driver);
        auditService.record("DRIVER", saved.getId(), "UPDATE", null, saved.getFullName());
        return DriverResponseDto.from(saved);
    }

    @Transactional
    public void deleteDriver(Long id) {
        Driver driver = driverRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Driver not found with id: " + id));
        driverRepository.delete(driver);
        auditService.record("DRIVER", id, "DELETE", driver.getFullName(), null);
    }
}
