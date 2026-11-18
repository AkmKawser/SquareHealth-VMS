**[Hands-on] Committing & Pushing the Two VMS Projects to GitHub**

**Overview:**Create a safe working state for both repositories before deployment. Review generated changes, commit intentionally, and push each project separately.

**Step 1: Review the Frontend Repository**

• Open GitHub Desktop with vms-frontend selected.

• Review changed files and make sure no secrets or local configuration files are included.

• Commit with a clear message such as complete VMS frontend integration.

• Push origin and verify the GitHub repository.

**Step 2: Review the Backend Repository**

• Switch GitHub Desktop to vms-backend.

• Review changed files and make sure database passwords/secrets are excluded.

• Commit with a clear message such as complete VMS backend API.

• Push origin and verify the GitHub repository.

**Step 3: Verify Repository Separation**

• Confirm the Flutter code exists only in vms-frontend.

• Confirm the Spring Boot code exists only in vms-backend.

• Confirm both repositories have readable README files.

**Antigravity Prompt**

Use GitHub Desktop to review both VMS repositories before deployment. Keep vms-frontend and vms-backend separate, verify that no secrets or local configuration files are staged, create clear commits, push origin for each repository, and verify the latest commit is visible on GitHub.

**Verification Checklist**

□ Both repositories are pushed.

□ No secrets are committed.

□ Frontend and backend remain separate.

□ GitHub shows the expected latest commits.