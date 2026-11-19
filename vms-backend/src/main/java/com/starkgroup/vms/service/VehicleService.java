package com.starkgroup.vms.service;

import com.starkgroup.vms.dto.PagedResponse;
import com.starkgroup.vms.dto.VehicleRequestDto;
import com.starkgroup.vms.dto.VehicleResponseDto;
import com.starkgroup.vms.entity.Driver;
import com.starkgroup.vms.entity.Vehicle;
import com.starkgroup.vms.entity.VehicleDocument;
import com.starkgroup.vms.enums.ExpiryStatus;
import com.starkgroup.vms.enums.VehicleStatus;
import com.starkgroup.vms.enums.VehicleType;
import com.starkgroup.vms.exception.BusinessRuleException;
import com.starkgroup.vms.exception.DuplicateResourceException;
import com.starkgroup.vms.exception.ResourceNotFoundException;
import com.starkgroup.vms.repository.DriverRepository;
import com.starkgroup.vms.repository.VehicleDocumentRepository;
import com.starkgroup.vms.repository.VehicleRepository;
import jakarta.persistence.criteria.Predicate;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.data.jpa.domain.Specification;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.ArrayList;
import java.util.List;

@Service
public class VehicleService {

    private static final List<VehicleStatus> ACTIVE_ASSIGNMENT_STATUSES =
            List.of(VehicleStatus.ACTIVE, VehicleStatus.IN_USE);

    private final VehicleRepository vehicleRepository;
    private final DriverRepository driverRepository;
    private final VehicleDocumentRepository documentRepository;
    private final AuditService auditService;

    public VehicleService(
            VehicleRepository vehicleRepository,
            DriverRepository driverRepository,
            VehicleDocumentRepository documentRepository,
            AuditService auditService) {
        this.vehicleRepository = vehicleRepository;
        this.driverRepository = driverRepository;
        this.documentRepository = documentRepository;
        this.auditService = auditService;
    }

    @Transactional(readOnly = true)
    public PagedResponse<VehicleResponseDto> getVehicles(
            int page,
            int size,
            String sortBy,
            String sortDir,
            String search,
            VehicleStatus status,
            VehicleType vehicleType,
            String company) {

        Sort.Direction direction = "asc".equalsIgnoreCase(sortDir) ? Sort.Direction.ASC : Sort.Direction.DESC;
        String safeSortField = switch (sortBy == null ? "" : sortBy) {
            case "vehicleNumber", "brand", "model", "company", "status", "manufacturingYear", "updatedAt" -> sortBy;
            default -> "createdAt";
        };
        Pageable pageable = PageRequest.of(Math.max(page, 0), Math.min(Math.max(size, 1), 100), Sort.by(direction, safeSortField));

        Specification<Vehicle> spec = (root, query, cb) -> {
            List<Predicate> predicates = new ArrayList<>();
            if (search != null && !search.isBlank()) {
                String pattern = "%" + search.trim().toLowerCase() + "%";
                predicates.add(cb.or(
                        cb.like(cb.lower(root.get("vehicleNumber")), pattern),
                        cb.like(cb.lower(root.get("brand")), pattern),
                        cb.like(cb.lower(root.get("model")), pattern),
                        cb.like(cb.lower(root.get("company")), pattern),
                        cb.like(cb.lower(root.get("driverName")), pattern)
                ));
            }
            if (status != null) {
                predicates.add(cb.equal(root.get("status"), status));
            }
            if (vehicleType != null) {
                predicates.add(cb.equal(root.get("vehicleType"), vehicleType));
            }
            if (company != null && !company.isBlank()) {
                predicates.add(cb.equal(cb.lower(root.get("company")), company.trim().toLowerCase()));
            }
            return cb.and(predicates.toArray(new Predicate[0]));
        };

        Page<VehicleResponseDto> result = vehicleRepository.findAll(spec, pageable)
                .map(v -> VehicleResponseDto.from(v, computeVehicleCompliance(v.getId())));
        return PagedResponse.from(result);
    }

    @Transactional(readOnly = true)
    public VehicleResponseDto getVehicleById(Long id) {
        Vehicle vehicle = findVehicleOrThrow(id);
        return VehicleResponseDto.from(vehicle, computeVehicleCompliance(id));
    }

    @Transactional
    public VehicleResponseDto createVehicle(VehicleRequestDto dto) {
        String normalizedPlate = dto.vehicleNumber().trim().toUpperCase();
        if (vehicleRepository.existsByVehicleNumberIgnoreCase(normalizedPlate)) {
            throw new DuplicateResourceException("Vehicle with number '" + normalizedPlate + "' already exists in the fleet.");
        }

        Vehicle vehicle = Vehicle.builder()
                .vehicleNumber(normalizedPlate)
                .company(dto.company().trim())
                .vehicleType(dto.vehicleType())
                .brand(dto.brand().trim())
                .model(dto.model().trim())
                .manufacturingYear(dto.manufacturingYear())
                .color(dto.color())
                .seatingCapacity(dto.seatingCapacity())
                .fuelType(dto.fuelType())
                .status(dto.status() != null ? dto.status() : VehicleStatus.AVAILABLE)
                .dailyRate(dto.dailyRate())
                .fuelLevel(dto.fuelLevel() != null ? dto.fuelLevel() : 100)
                .odometerKm(dto.odometerKm() != null ? dto.odometerKm() : 0)
                .department(dto.department())
                .build();

        applyDriverFields(vehicle, dto.driverId(), dto.driverName(), dto.driverPhone(), null);
        Vehicle saved = vehicleRepository.save(vehicle);
        auditService.record("VEHICLE", saved.getId(), "CREATE", null, saved.getVehicleNumber());
        return VehicleResponseDto.from(saved, ExpiryStatus.VALID);
    }

    @Transactional
    public VehicleResponseDto updateVehicle(Long id, VehicleRequestDto dto) {
        Vehicle vehicle = findVehicleOrThrow(id);
        String normalizedPlate = dto.vehicleNumber().trim().toUpperCase();

        if (vehicleRepository.existsByVehicleNumberIgnoreCaseAndIdNot(normalizedPlate, id)) {
            throw new DuplicateResourceException("Vehicle with number '" + normalizedPlate + "' already exists in the fleet.");
        }

        String oldStatus = vehicle.getStatus().name();
        vehicle.setVehicleNumber(normalizedPlate);
        vehicle.setCompany(dto.company().trim());
        vehicle.setVehicleType(dto.vehicleType());
        vehicle.setBrand(dto.brand().trim());
        vehicle.setModel(dto.model().trim());
        vehicle.setManufacturingYear(dto.manufacturingYear());
        vehicle.setColor(dto.color());
        vehicle.setSeatingCapacity(dto.seatingCapacity());
        vehicle.setFuelType(dto.fuelType());
        if (dto.status() != null) {
            vehicle.setStatus(dto.status());
        }
        vehicle.setDailyRate(dto.dailyRate());
        if (dto.fuelLevel() != null) {
            vehicle.setFuelLevel(dto.fuelLevel());
        }
        if (dto.odometerKm() != null) {
            vehicle.setOdometerKm(dto.odometerKm());
        }
        vehicle.setDepartment(dto.department());

        applyDriverFields(vehicle, dto.driverId(), dto.driverName(), dto.driverPhone(), id);
        Vehicle saved = vehicleRepository.save(vehicle);
        auditService.record("VEHICLE", saved.getId(), "UPDATE", oldStatus, saved.getStatus().name());
        return VehicleResponseDto.from(saved, computeVehicleCompliance(saved.getId()));
    }

    @Transactional
    public VehicleResponseDto assignDriver(Long vehicleId, Long driverId) {
        Vehicle vehicle = findVehicleOrThrow(vehicleId);
        if (driverId == null) {
            vehicle.setDriver(null);
            vehicle.setDriverName(null);
            vehicle.setDriverPhone(null);
            Vehicle saved = vehicleRepository.save(vehicle);
            auditService.record("VEHICLE", vehicleId, "UNASSIGN_DRIVER", null, "Unassigned");
            return VehicleResponseDto.from(saved, computeVehicleCompliance(vehicleId));
        }

        Driver driver = driverRepository.findById(driverId)
                .orElseThrow(() -> new ResourceNotFoundException("Driver not found with id: " + driverId));
        if (!driver.isEligible()) {
            throw new BusinessRuleException("Driver is inactive, medically uncleared, or has an expired license.");
        }
        if (ACTIVE_ASSIGNMENT_STATUSES.contains(vehicle.getStatus())
                && vehicleRepository.existsByDriverIdAndStatusInAndIdNot(driverId, ACTIVE_ASSIGNMENT_STATUSES, vehicleId)) {
            throw new BusinessRuleException("Driver is already assigned to an active transit vehicle.");
        }

        vehicle.setDriver(driver);
        vehicle.setDriverName(driver.getFullName());
        vehicle.setDriverPhone(driver.getPhone());
        Vehicle saved = vehicleRepository.save(vehicle);
        auditService.record("VEHICLE", vehicleId, "ASSIGN_DRIVER", null, driver.getFullName());
        return VehicleResponseDto.from(saved, computeVehicleCompliance(vehicleId));
    }

    @Transactional
    public void deleteVehicle(Long id) {
        Vehicle vehicle = findVehicleOrThrow(id);
        vehicleRepository.delete(vehicle);
        auditService.record("VEHICLE", id, "DELETE", vehicle.getVehicleNumber(), null);
    }

    private Vehicle findVehicleOrThrow(Long id) {
        return vehicleRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Vehicle not found with id: " + id));
    }

    private void applyDriverFields(Vehicle vehicle, Long driverId, String driverName, String driverPhone, Long currentVehicleId) {
        if (driverId != null) {
            Driver driver = driverRepository.findById(driverId)
                    .orElseThrow(() -> new ResourceNotFoundException("Driver not found with id: " + driverId));
            if (!driver.isEligible()) {
                throw new BusinessRuleException("Driver is inactive, medically uncleared, or has an expired license.");
            }
            if (ACTIVE_ASSIGNMENT_STATUSES.contains(vehicle.getStatus())) {
                boolean conflict = currentVehicleId == null
                        ? vehicleRepository.existsByDriverIdAndStatusIn(driverId, ACTIVE_ASSIGNMENT_STATUSES)
                        : vehicleRepository.existsByDriverIdAndStatusInAndIdNot(driverId, ACTIVE_ASSIGNMENT_STATUSES, currentVehicleId);
                if (conflict) {
                    throw new BusinessRuleException("Driver is already assigned to an active transit vehicle.");
                }
            }
            vehicle.setDriver(driver);
            vehicle.setDriverName(driver.getFullName());
            vehicle.setDriverPhone(driver.getPhone());
        } else {
            vehicle.setDriver(null);
            vehicle.setDriverName(driverName);
            vehicle.setDriverPhone(driverPhone);
        }
    }

    public ExpiryStatus computeVehicleCompliance(Long vehicleId) {
        List<VehicleDocument> docs = documentRepository.findByVehicleIdOrderByUploadedAtDesc(vehicleId);
        ExpiryStatus worst = ExpiryStatus.VALID;
        for (VehicleDocument doc : docs) {
            ExpiryStatus status = doc.computeExpiryStatus();
            if (status == ExpiryStatus.EXPIRED) {
                return ExpiryStatus.EXPIRED;
            }
            if (status == ExpiryStatus.EXPIRING_SOON) {
                worst = ExpiryStatus.EXPIRING_SOON;
            }
        }
        return worst;
    }
}
