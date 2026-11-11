**[Hands-on] Deploying Flutter Web to Netlify**

**Overview:**Connect the separate Flutter frontend repository to Netlify, configure the Flutter Web build, and publish the frontend as a live site.

**Step 1: Create/Connect the Netlify Site**

• Sign in to Netlify using GitHub.

• Choose Add new site / Import an existing project.

• Select GitHub and choose vms-frontend.

**Step 2: Configure the Flutter Web Build**

• Set the production build command to the Flutter Web build command used by the project.

• Set the publish directory to the generated Flutter Web output directory.

• Set the branch to the branch you intend to deploy, normally main.

**Step 3: Configure the Production API URL**

• Add the production backend URL using the frontend configuration mechanism chosen during development.

• Do not put database credentials or backend secrets in the Flutter application.

**Step 4: Deploy & Verify**

• Start the deployment.

• Wait for the build to finish.

• Open the generated Netlify URL.

• Confirm the application loads before connecting the live backend.

**Antigravity Prompt**

@workspace Review the Flutter Web project for production deployment. Verify the web build command, output directory, routing requirements, and production API base URL configuration. Do not expose secrets. Run flutter analyze and flutter build web and report any deployment-specific issue before I push the changes.

**Verification Checklist**

□ Netlify build succeeds.

□ Flutter Web opens from the live URL.

□ Production API URL is configured correctly.

□ No secrets are exposed in the frontend.