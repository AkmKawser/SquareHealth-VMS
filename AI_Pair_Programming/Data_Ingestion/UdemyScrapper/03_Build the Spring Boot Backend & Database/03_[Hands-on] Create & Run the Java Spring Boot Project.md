**[Hands-on] Creating & Running the Java Spring Boot Backend**

**Overview:**Create the second independent VMS project using Java Spring Boot. The backend will own business rules, REST APIs, and database access; the Flutter project will never contain backend code.

**Step 1: Create the Spring Boot Project**

• Open the vms-backend repository.

• Use Spring Initializr or the supported project generator.

• Use Java with Maven and select Spring Web, Spring Data JPA, Validation, and the SQL database driver selected for the course. Add Spring Security when implementing authentication.

**Step 2: Open & Run the Backend**

• Open the generated project in Antigravity.

• Run the Spring Boot application.

• Confirm that the application starts without errors and listens on the configured local port.

**Step 3: Establish the Backend Package Structure**

• Ask Antigravity to create a clean structure for controller, service, repository, entity/model, DTO, and exception handling responsibilities.

• Do not implement vehicle CRUD yet; this step is only the foundation.

**Step 4: Verify**

• Run the Maven test/build command appropriate for the project.

• Confirm the application starts again after the structure changes.

**Antigravity Prompt**

@workspace You are my Lead Java/Spring Boot Engineer. We are building the backend for a Vehicle Management System (VMS). This is a separate project from a Flutter Web frontend. Use a clean layered architecture: controller, service, repository, entity/model, DTO, validation, and exception handling. The backend will expose REST APIs and own all business rules. Do not create Flutter code. Do not connect the frontend yet. After setup, run the project build/tests and fix compilation issues.

**Verification Checklist**

□ Spring Boot starts successfully.

□ The backend project is independent of vms-frontend.

□ The basic layered structure is present.

□ The project builds/tests successfully.