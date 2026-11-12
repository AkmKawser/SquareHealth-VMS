@echo off
title SquareHealth-VMS Java Web Server
echo =============================================================
echo   SquareHealth-VMS Java Web Server (OpenJDK 21)
echo   Local URL:  http://localhost:8080/
echo   Server Engine: Java 21 Simple Web Server (jwebserver)
echo =============================================================
jwebserver -p 8080 -d "%CD%"
pause
