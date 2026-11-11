**[Hands-on] Deploying the Java Spring Boot Backend to Render**

**Overview:**Deploy the separate Spring Boot backend repository, configure its production environment and SQL connection, and expose the REST API for the live Flutter Web frontend.

**Step 1: Create the Render Service**

• Sign in to Render and create a new Web Service from GitHub.

• Select vms-backend.

• Choose the appropriate Java/Maven build and start commands for the project.

**Step 2: Configure Environment Variables**

• Add the production database URL/host, username, password, and any authentication configuration as environment variables.

• Never commit production secrets to GitHub.

• Use the Render environment configuration rather than hard-coding credentials.

**Step 3: Configure CORS**

• Allow requests from the deployed Flutter Web domain.

• Do not use a wildcard production policy unless the course explicitly requires it.

• Ask Antigravity to review the CORS configuration if the browser blocks API calls.

**Step 4: Deploy & Verify the API**

• Deploy the service.

• Open a public health endpoint or API documentation endpoint if the project provides one.

• Test a CRUD endpoint with the production API URL.

• Record the production API base URL for the Flutter frontend.

**Antigravity Prompt**

@workspace Prepare this Spring Boot VMS backend for Render deployment. Review the build/start configuration, environment-based database settings, server port configuration, CORS for the production Flutter Web domain, and health endpoint. Do not hard-code secrets. Run the test/build process and identify any deployment issue before I push.

**Verification Checklist**

□ Render deployment succeeds.

□ Spring Boot starts without database/configuration errors.

□ The production API responds.

□ CORS allows the intended Flutter Web origin only.