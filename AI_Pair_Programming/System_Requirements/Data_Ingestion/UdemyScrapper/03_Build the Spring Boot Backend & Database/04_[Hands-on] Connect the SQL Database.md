**[Hands-on] Connecting the SQL Database to Spring Boot**

**Overview:**Prepare the SQL database and connect it to Spring Boot before implementing the vehicle CRUD APIs. The database schema should be explicit rather than guessed by the AI.

**Step 1: Create the Database**

• Create the SQL database using the database service selected for the course.

• Record the database name, host, port, username, and password securely.

• Do not commit passwords or private connection strings to GitHub.

**Step 2: Configure Spring Boot**

• Add the database driver and JPA configuration.

• Use environment variables or a local configuration file that is excluded from Git.

• Configure the application to connect to the SQL database.

**Step 3: Verify the Connection**

• Start Spring Boot.

• Use a simple health/check endpoint or startup verification to confirm the database connection.

• Do not build the complete vehicle feature yet.

**Step 4: Ask AI to Diagnose Connection Errors**

• If startup fails, copy the exact error into Antigravity.

• Ask it to explain the cause first, then propose the smallest fix.

• Re-run the application after the fix.

**Antigravity Prompt**

@workspace Configure this Spring Boot project to connect to our SQL database. Keep credentials out of source control. Use Spring Data JPA and environment-based configuration. Create only the database connectivity foundation at this stage. Add a simple health check if useful. Do not invent vehicle fields or tables yet. After the change, run the build/tests and verify the application starts.

**Verification Checklist**

□ Spring Boot starts with the database configured.

□ Credentials are not committed to Git.

□ A database connectivity check succeeds.

□ The project still builds cleanly.