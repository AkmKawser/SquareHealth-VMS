**[Hands-on] Connecting the Complete Vehicle CRUD Flow**

**Overview:**Complete the real VMS workflow by wiring the existing frontend screens to the backend Create, Read, Update, and Delete endpoints.

**Step 1: Connect the Vehicle List**

• Load vehicles from the backend when the screen opens.

• Show loading, empty, error, and success states.

• Do not fall back silently to mock data once the real API is enabled.

**Step 2: Connect Register & Update**

• Submit the Flutter form to the backend.

• Display validation errors returned by the API.

• After a successful save, refresh or update the list without creating duplicate records.

**Step 3: Connect Delete**

• Show a confirmation dialog.

• Call the backend delete endpoint.

• Remove the record from the UI only after the backend confirms success.

**Step 4: Verify the Full Local Flow**

• Login → Register Vehicle → View → Update → Delete.

• Check the SQL database after each operation.

• Intentionally trigger a duplicate Vehicle Number and confirm the frontend displays the backend error clearly.

**Antigravity Prompt**

@workspace Finish the real VMS CRUD integration. Connect the existing Flutter Vehicle List and Register/Edit screens to the existing Spring Boot API. Preserve the current UI/UX. Map backend validation and error responses into user-friendly messages. Delete only after backend success, and keep loading/empty/error states consistent. Run flutter analyze and flutter build web after the changes.

**Verification Checklist**

□ All CRUD operations work from Flutter.

□ Database state matches the UI.

□ Duplicate Vehicle Number errors are handled correctly.

□ The complete authenticated local journey works.