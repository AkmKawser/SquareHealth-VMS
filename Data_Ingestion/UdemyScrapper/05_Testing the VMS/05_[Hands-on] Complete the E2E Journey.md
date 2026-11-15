**[Hands-on] Completing the VMS End-to-End Journey**

**Overview:**Test the complete user journey through the real Flutter Web frontend, Spring Boot API, and SQL database rather than testing each layer separately.

**Step 1: Start the Full Local Stack**

• Start the SQL database.

• Start the Spring Boot backend.

• Start Flutter Web.

• Confirm Flutter is configured to use the local backend URL.

**Step 2: Run the Happy Path**

• Login with a valid user.

• Register a new vehicle.

• Confirm it appears in the Vehicle List.

• Update one field.

• Confirm the changed value appears.

• Delete the vehicle and confirm removal.

**Step 3: Run an Error Path**

• Try to register the same Vehicle Number twice.

• Submit invalid or incomplete data.

• Confirm the UI handles the backend responses without crashing.

**Step 4: Record the Result**

• Use the course checklist to mark each step Pass/Fail.

• Any failure should be fixed and rerun before moving to deployment.

**Antigravity Prompt**

@workspace Help me diagnose an E2E VMS failure. I will provide the exact step, browser error, API response, and relevant backend log. Trace the failure across Flutter Web → REST API → Spring Boot → SQL. Do not guess. Identify the most likely failing layer from the evidence, propose the smallest fix, and tell me exactly what to retest.

**Verification Checklist**

□ Login works.

□ Create, Read, Update, and Delete work through the real UI.

□ Duplicate/validation errors are handled.

□ No local mock data is involved in the final E2E test.