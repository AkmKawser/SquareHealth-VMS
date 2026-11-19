package com.starkgroup.vms.repository;

import com.starkgroup.vms.entity.Driver;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

public interface DriverRepository extends JpaRepository<Driver, Long> {
    boolean existsByLicenseNumberIgnoreCase(String licenseNumber);
    boolean existsByLicenseNumberIgnoreCaseAndIdNot(String licenseNumber, Long id);

    @Query("""
           SELECT d FROM Driver d
           WHERE (:search IS NULL OR :search = ''
             OR LOWER(d.fullName) LIKE LOWER(CONCAT('%', :search, '%'))
             OR LOWER(d.licenseNumber) LIKE LOWER(CONCAT('%', :search, '%'))
             OR LOWER(d.phone) LIKE LOWER(CONCAT('%', :search, '%')))
           """)
    Page<Driver> searchDrivers(@Param("search") String search, Pageable pageable);
}
