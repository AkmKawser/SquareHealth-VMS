**[Hands-on] Creating the Vehicle REST APIs**

**Overview:**Expose the backend business logic through a clean REST API. The API will be ready for the Flutter frontend, but the two projects remain separate until the integration section.

**Step 1: Define the API Contract**

• Create endpoints for Create, Read, Update, and Delete.

• Use JSON request/response DTOs rather than exposing persistence entities directly.

• Return appropriate HTTP status codes and useful validation errors.

**Step 2: Generate the REST Controller**

• Use the prompt below in Antigravity.

• Review the endpoint paths and payloads before testing them.

**Step 3: Test the APIs Independently**

• Use Postman, curl, or another API client.

• Create a vehicle.

• Fetch the vehicle list.

• Update the vehicle.

• Delete the vehicle.

• Attempt a duplicate Vehicle Number and confirm the business rule rejects it.

**Step 4: Record the API Contract**

• Create a small API documentation file in the backend repository.

• Document endpoint, method, request body, response, and common error cases.

**Antigravity Prompt**

@workspace Create the VMS Vehicle REST API using the existing service layer. Implement endpoints for create, list/read, update, and delete. Use request/response DTOs, Bean Validation, consistent error responses, and appropriate HTTP status codes. Do not expose JPA entities directly. Preserve the duplicate Vehicle Number business rule. Add controller/integration tests for the CRUD endpoints. After implementation, run the test suite.

**Verification Checklist**

□ Create, Read, Update, and Delete endpoints work independently.

□ Validation errors are clear.

□ Duplicate Vehicle Number is rejected.

□ The API can be tested without the Flutter frontend.