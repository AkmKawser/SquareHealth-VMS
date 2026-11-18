**[Hands-on] Creating & Running the Flutter Web Project**

**Overview:**Create the separate Flutter Web project, run it locally, and establish a clean frontend foundation before any backend integration. The first frontend version uses mock/static data.

**Step 1: Create the Flutter Project**

• Open the vms-frontend repository in Antigravity.

![image](https://img-c.udemycdn.com/redactor/raw/article_lecture/2026-09-28_11-22-38-67169f066e2a4accabd4b9cf8f6117cd.png)

![image](https://img-c.udemycdn.com/redactor/raw/article_lecture/2026-09-28_11-22-39-6166c1010a5d4524e5a712b19bb7e26b.png)

• Create the Flutter project in the repository root. Use a package/project name such as vms_frontend.

• Enable web support and confirm Chrome or another supported browser is available for local execution.

**Step 2: Run the Starter Application**

• Run flutter pub get.

![image](https://img-c.udemycdn.com/redactor/raw/article_lecture/2026-09-28_11-22-39-665ff15f23dd3da861eaee9bdc98e89b.png)

• Run the project in Chrome with flutter run -d chrome.

![image](https://img-c.udemycdn.com/redactor/raw/article_lecture/2026-09-28_11-22-39-d82e4685a1601b7a290adad88ee2d1bc.png)

• Confirm that the default Flutter application opens in the browser.

![image](https://img-c.udemycdn.com/redactor/raw/article_lecture/2026-09-28_11-22-39-cdf0d86a87da516529330c2f02e78ba6.png)

**Step 3: Ask Antigravity to Establish the Frontend Foundation**

• Open the AI Chat/Agent panel.

• Use the course prompt below.

• Allow terminal commands only when you understand what the agent is executing.

**Step 4: Verify the Foundation**

• Ask the agent to run flutter analyze.

• Ask it to run flutter build web.

• Open the local web build and confirm that there are no compilation errors.

**Antigravity Prompt**

@workspace You are my Lead Flutter Engineer. We are building a Vehicle Management System (VMS) as a Flutter Web frontend. This is a separate project from a Java Spring Boot backend. Create a clean, responsive desktop-first admin application foundation using Material 3. For now use mock/static data only; do not create API calls or backend code. Establish a clear structure for screens, reusable widgets, theme, routing/navigation, and models. The planned screens are Login, Vehicle List, Register/Edit Vehicle, and a simple application shell. Keep the implementation clean and easy for a beginner to understand. After making changes, run flutter analyze and fix any issues.

**Verification Checklist**

□ Flutter Web runs locally.

□ The project builds successfully with flutter build web.

□ The project contains only frontend code.

□ No API/database dependency has been introduced yet.