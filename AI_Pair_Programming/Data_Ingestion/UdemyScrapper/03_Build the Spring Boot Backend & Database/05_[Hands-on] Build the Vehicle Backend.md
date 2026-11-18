**[Hands-on] Building the Vehicle Backend**

**Overview:**Create the Vehicle entity, repository, service layer, validation, and business rule for duplicate Vehicle Numbers. The backend becomes the single source of truth for vehicle data.

**Step 1: Define the Vehicle Schema**

• Use the exact course fields: Vehicle Number, Company, Type, Brand, Model, and Status.

• Choose appropriate database types and a generated primary key.

• Make Vehicle Number unique at both the business-rule and database level where appropriate.

**Step 2: Generate the Backend Layers**

• Open the backend project in Antigravity.

• Use the master prompt below to create the entity, repository, DTOs, service, validation, and exception handling.

• Review generated files before moving on.

**Step 3: Implement the Duplicate Vehicle Rule**

• Attempting to create a Vehicle with an existing Vehicle Number must be rejected.

• Return a clear client-safe error response.

• Keep the rule in the service/business layer rather than only in the controller.

**Step 4: Verify with Tests**

• Run the backend test suite.

• Confirm the duplicate Vehicle Number scenario is covered.

• Fix compilation or test failures before creating the REST controller.

**Antigravity Prompt**

@workspace Build the Vehicle domain for our VMS backend. Create a Vehicle entity with: vehicleNumber, company, type, brand, model, and status, plus a generated primary key. Create a repository, request/response DTOs, service layer, validation, and a clear exception for duplicate vehicleNumber. Vehicle Number must be unique. Keep business rules in the service layer and persistence in the repository layer. Do not create Flutter code. Add focused unit tests for the duplicate Vehicle Number rule. Run the tests and fix failures.

**Verification Checklist**

□ Vehicle entity maps correctly to SQL.

□ Vehicle Number is treated as unique.

□ Service rejects duplicate Vehicle Numbers.

□ Focused unit tests pass.