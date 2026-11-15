**[Hands-on] Final Live Check & Troubleshooting**

**Overview:**Step out of the developer role and test the VMS as a real user. Verify the live Flutter Web application, live Spring Boot API, and production SQL database as one system.

**Step 1: The End-to-End Happy Path**

• Open an incognito/private browser window.

• Open the live Flutter Web URL.

• Log in with the course test account.

• Register a test vehicle.

• Verify it appears in the vehicle list.

• Update it and verify the change.

• Delete it and confirm removal.

**Step 2: Production Edge Cases**

• Submit incomplete vehicle data.

• Try a duplicate Vehicle Number.

• Refresh the page and verify data is still loaded from the backend.

• Open the browser's device toolbar and check the core screens at a smaller width.

**Step 3: Troubleshooting Matrix**

• Blank screen: inspect browser console and Netlify build logs; verify the production frontend configuration.

• API request blocked: inspect the browser Network tab and verify the Spring Boot CORS configuration.

• 500/DB error: inspect Render logs and verify production database environment variables.

• Works locally but not online: compare local and production API base URLs, environment variables, and build configuration.

**Step 4: Agent Support Loop**

• Copy the exact browser error, HTTP status, API response, or Render/Netlify log.

• Paste the evidence into Antigravity and identify the affected file/layer.

• Ask the agent for the smallest fix, rebuild locally, push the fix, and repeat the live test.

**Antigravity Prompt**

My production VMS has failed this exact test: [PASTE TEST STEP]. Here is the exact browser error/API response/log: [PASTE EVIDENCE]. Trace the problem across Flutter Web, REST API, Spring Boot, CORS/configuration, and SQL. Do not regenerate the application. Identify the failing layer, explain the evidence, make the smallest fix, verify locally, and tell me exactly what production step to retest.

**Verification Checklist**

□ Live login works.

□ Live CRUD works.

□ Database changes persist.

□ Common production errors are diagnosed from evidence rather than guessed.

□ The final live VMS journey passes.