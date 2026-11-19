package com.starkgroup.vms.repository;

import com.starkgroup.vms.entity.Vehicle;
import com.starkgroup.vms.enums.VehicleStatus;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.data.jpa.repository.Query;

import java.util.List;

public interface VehicleRepository extends JpaRepository<Vehicle, Long>, JpaSpecificationExecutor<Vehicle> {
    boolean existsByVehicleNumberIgnoreCase(String vehicleNumber);
    boolean existsByVehicleNumberIgnoreCaseAndIdNot(String vehicleNumber, Long id);
    long countByStatus(VehicleStatus status);
    long countByFuelLevelLessThanEqual(Integer threshold);
    boolean existsByDriverIdAndStatusIn(Long driverId, List<VehicleStatus> statuses);
    boolean existsByDriverIdAndStatusInAndIdNot(Long driverId, List<VehicleStatus> statuses, Long vehicleId);

    @Query("SELECT v.company, COUNT(v) FROM Vehicle v GROUP BY v.company")
    List<Object[]> countGroupedByCompany();

    @Query("SELECT v.status, COUNT(v) FROM Vehicle v GROUP BY v.status")
    List<Object[]> countGroupedByStatus();
}
