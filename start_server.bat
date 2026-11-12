@echo off
title SquareHealth-VMS Backend Server (Spring Boot / Maven)
echo =============================================================
echo   SquareHealth-VMS Java Spring Boot Backend Server
echo   Engine: Spring Boot on OpenJDK 21 (Embedded Tomcat)
echo   CLI:    Apache Maven (mvn / mvnw)
echo   API:    http://localhost:8080/api/v1/vehicles
echo =============================================================
cd vms-backend
if exist mvnw.cmd (
    call mvnw.cmd spring-boot:run
) else (
    call mvn spring-boot:run
)
pause
