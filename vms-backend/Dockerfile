# =============================================================================
# Stage 1: Build & Package Spring Boot Application
# =============================================================================
FROM eclipse-temurin:21-jdk-alpine AS builder

WORKDIR /build

# Copy Maven Wrapper and POM first for layer caching
COPY .mvn/ .mvn/
COPY mvnw pom.xml ./
RUN ./mvnw dependency:go-offline -B

# Copy source code and build executable JAR
COPY src/ src/
RUN ./mvnw clean package -DskipTests

# =============================================================================
# Stage 2: Minimal Production Runtime
# =============================================================================
FROM eclipse-temurin:21-jre-alpine

WORKDIR /app

# Create unprivileged service user for security
RUN addgroup -S vmsgroup && adduser -S vmsuser -G vmsgroup
USER vmsuser

# Copy executable fat JAR from builder stage
COPY --from=builder /build/target/vms-backend-*.jar app.jar

EXPOSE 8080

HEALTHCHECK --interval=30s --timeout=5s --start-period=30s --retries=3 \
  CMD wget --no-verbose --tries=1 --spider http://localhost:8080/actuator/health || exit 1

ENTRYPOINT ["java", "-Djava.security.egd=file:/dev/./urandom", "-jar", "app.jar"]

