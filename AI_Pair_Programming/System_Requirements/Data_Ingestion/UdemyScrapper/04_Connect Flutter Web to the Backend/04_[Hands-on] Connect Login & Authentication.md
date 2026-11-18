**[Hands-on] Connecting Login & Authentication**

**Overview:**Connect the existing Flutter Login UI to the backend authentication flow. The exact authentication mechanism should be implemented consistently in Spring Boot and represented by the Flutter client.

**Step 1: Define the Authentication Contract**

• Decide the course credentials and authentication response format.

• Document the login endpoint, request, response, and failure response.

• Keep passwords out of logs and source control.

**Step 2: Implement Backend Authentication**

• Use Spring Security and a simple course-appropriate user store or database-backed user model.

• Return an authentication result/token according to the chosen implementation.

• Protect vehicle endpoints so unauthenticated users cannot perform vehicle operations.

**Step 3: Connect the Flutter Login Screen**

• Ask Antigravity to connect the existing Login UI to the authentication endpoint.

• Show a clear error for invalid credentials.

• Persist the minimum session information needed by the chosen authentication design.

**Step 4: Verify the Protected Journey**

• Login with valid credentials.

• Attempt a vehicle operation after authentication.

• Verify that unauthorized access is rejected.

**Antigravity Prompt**

@workspace Connect the existing VMS Flutter Login screen to the Spring Boot authentication API. First inspect the backend authentication contract; do not invent a different protocol. Implement a clean auth service and session handling in Flutter, keep credentials secure, show user-friendly login errors, and protect vehicle operations according to the backend's authentication mechanism. Do not redesign the login screen unless needed for the integration.

**Verification Checklist**

□ Valid login succeeds.

□ Invalid credentials produce a clear error.

□ Protected vehicle operations require authentication.

□ No password is logged or stored insecurely.