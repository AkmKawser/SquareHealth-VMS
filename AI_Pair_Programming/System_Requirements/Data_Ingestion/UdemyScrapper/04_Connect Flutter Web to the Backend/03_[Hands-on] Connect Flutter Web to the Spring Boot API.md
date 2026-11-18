**[Hands-on] Connecting Flutter Web to the Spring Boot API**

**Overview:**The frontend is already complete with mock data and the backend is already complete with REST APIs. Now replace the mock data path with real HTTP communication.

**Step 1: Define the API Base URL**

• Configure the Flutter Web application with a development API base URL.

• Keep the URL configurable so the production Render URL can be supplied later.

• Do not hard-code secrets into Flutter.

**Step 2: Create the API Client**

• Ask Antigravity to create a small, reusable HTTP/API client.

• Create request/response models that match the backend contract.

• Add loading, success, and error states.

**Step 3: Replace Mock Vehicle Data**

• Replace the Vehicle List mock repository with the real API repository.

• Connect Create, Update, and Delete actions.

• Keep the UI widgets independent from raw HTTP code.

**Step 4: Verify the Integration**

• Run Spring Boot locally.

• Run Flutter Web locally.

• Create a vehicle in Flutter and verify it appears in the SQL database.

• Refresh the Flutter list and confirm the data comes from the backend.

**Antigravity Prompt**

@workspace Replace the VMS frontend's mock vehicle data with the Spring Boot REST API. Create a clean API/data layer so widgets do not contain raw HTTP code. Use the existing backend API contract exactly; do not invent endpoint names or fields. Support list, create, update, and delete. Add loading, empty, success, and error states. Keep the API base URL configurable for development and production. After implementation, run flutter analyze and flutter build web.

**Verification Checklist**

□ Flutter can read real vehicle data.

□ Create/update/delete from Flutter changes the SQL database.

□ API errors are displayed gracefully.

□ The UI does not contain raw HTTP implementation details.