**[Hands-on] Building the VMS UI/UX with Antigravity**

**Overview:**Build the complete first-pass VMS interface before connecting any backend. The goal is to make the user experience work with mock data so students can focus on screens, navigation, forms, and visual consistency.

**Step 1: Define the VMS Screen Map**

• Create a Login screen.

• Create the main application shell with navigation.

• Create the Vehicle List screen.

• Create the Register/Edit Vehicle form.

• Use mock vehicle records so the list and form can be demonstrated without an API.

**Step 2: Generate the First UI Pass**

• Open the Flutter project in Antigravity.

• Paste the master prompt below.

• Let the agent complete one coherent pass before moving to smaller micro-prompts.

**Step 3: Polish with Micro-Prompts**

• Ask the agent to refine the navigation, table/list layout, form spacing, buttons, empty state, loading state, and validation messages one component at a time.

• Keep the visual language consistent with the Stark Group design guideline.

• Do not ask the agent to introduce API calls yet.

**Step 4: Agentic Verification**

• Run flutter analyze.

• Run flutter build web.

• Launch the web application and manually walk through Login → Vehicle List → Register Vehicle → Edit Vehicle.

• Fix UI or navigation problems before committing.

**Antigravity Prompt**

@workspace Build the first complete UI/UX for our Vehicle Management System (VMS) in Flutter Web. This is frontend-only at this stage. Do NOT create API clients, HTTP calls, authentication services, or database code.

Create a professional responsive admin interface with:
- Login screen
- Application shell with navigation
- Vehicle List screen
- Register/Edit Vehicle screen
- Mock vehicle data

Vehicle fields are: Vehicle Number, Company, Type, Brand, Model, and Status.

Use Material 3, reusable widgets, consistent spacing, accessible labels, clear validation messages, responsive desktop/tablet behavior, and a professional Stark Group visual style. Keep the architecture simple and maintainable. After implementation, run flutter analyze and flutter build web, fix errors, and then stop.

**Useful Micro-Prompts**

@workspace Review the Vehicle List UI. Make the table/list easy to scan, highlight Vehicle Number and Status, add a clear Edit and Delete action, and provide a polished empty state. Keep the existing design language.

@workspace Review the Register/Edit Vehicle form. Improve field grouping, labels, validation messages, spacing, and primary/secondary actions. Keep it responsive and do not add API calls.

@workspace Review the entire VMS frontend for inconsistent spacing, typography, button styles, and colors. Fix only UI/UX inconsistencies without changing business behavior.

**Verification Checklist**

□ All four core screens are reachable.

□ Mock data can be displayed, created/edited/deleted locally as designed.

□ No backend/API dependency exists.

□ flutter analyze and flutter build web succeed.