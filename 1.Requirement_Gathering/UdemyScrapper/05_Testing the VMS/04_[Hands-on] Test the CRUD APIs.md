**[Hands-on] Testing the CRUD APIs**

**Overview:**Test the Spring Boot API as an integrated backend system: controller, service, repository, and SQL database working together.

**Step 1: Start the Backend & Database**

• Start the SQL database.

• Start Spring Boot.

• Confirm the application can connect to the database.

**Step 2: Run the CRUD Scenario**

• Create a vehicle.

• Read the vehicle list.

• Update the vehicle.

• Read it again and verify the changed value.

• Delete the vehicle.

• Read again and confirm it is gone.

**Step 3: Test Business and Validation Errors**

• Submit a duplicate Vehicle Number.

• Submit missing required fields.

• Request a non-existent vehicle ID where applicable.

• Verify status codes and error bodies are consistent.

**Step 4: Use AI to Fix One Failure**

• Copy the exact failing request/response or test output.

• Paste it into Antigravity.

• Ask the agent to identify the root cause, make the smallest correction, and rerun the test.

**Antigravity Prompt**

@workspace Analyze this failing VMS CRUD API test. Do not regenerate the application. Identify the exact layer responsible (controller, service, repository, database, validation, or configuration), explain the root cause briefly, apply the smallest safe fix, and rerun the relevant test.

**Verification Checklist**

□ CRUD operations work against the real database.

□ Validation and duplicate errors are consistent.

□ The backend test suite remains green after the fix.