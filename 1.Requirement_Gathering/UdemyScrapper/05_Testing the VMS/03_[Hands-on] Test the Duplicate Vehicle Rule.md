**[Hands-on] Writing the Duplicate Vehicle Rule Unit Test**

**Overview:**Use the duplicate Vehicle Number rule as the first focused backend unit test. The goal is to prove one business rule in isolation before relying on the complete application.

**Step 1: Identify the Unit Under Test**

• Locate the Vehicle service method responsible for creating a vehicle.

• Identify the repository call used to detect an existing Vehicle Number.

• Keep the test independent of the real SQL database by mocking the repository.

**Step 2: Ask Antigravity to Generate the Test**

• Use the prompt below.

• Review the test to make sure it verifies behavior rather than implementation details.

**Step 3: Run the Test**

• Run the focused test.

• Confirm that an existing Vehicle Number causes the expected business exception.

• Also verify that a new Vehicle Number is accepted.

**Step 4: Break & Fix**

• Temporarily change the rule so the duplicate test fails.

• Run the test and inspect the failure.

• Ask Antigravity to identify the smallest fix.

• Restore the correct implementation and run the test again.

**Antigravity Prompt**

@workspace Create a focused unit test for the Vehicle service's duplicate Vehicle Number rule. Mock the repository so the test does not require a real database. Cover at least: existing Vehicle Number is rejected with the expected business exception, and a new Vehicle Number is accepted. Keep the test readable and behavior-focused. Run the test and fix any failure.

**Verification Checklist**

□ The unit test does not require a live database.

□ Duplicate Vehicle Number fails as expected.

□ New Vehicle Number succeeds.

□ The test is repeatable.