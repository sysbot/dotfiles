---
name: mr-review
description: Review and approve GitLab merge requests using glab CLI
tools:
  - Bash
  - Read
  - Grep
  - WebFetch
---

# MR Code Review and Approval

Review GitLab merge requests and approve them using the glab CLI.

## When This Activates

Use this skill when user provides:
- An MR URL like `https://gitlab-master.nvidia.com/maglev-sre/maglev-infra/-/merge_requests/2527`
- An MR number like `!2527` or `2527`
- A request to "review MR", "approve MR", or "code review"

## Workflow

### 1. Parse MR Reference

Extract project and MR number from input:
```bash
# From URL: https://gitlab-master.nvidia.com/maglev-sre/maglev-infra/-/merge_requests/2527
# Project: maglev-sre/maglev-infra
# MR: 2527

# From number: !2527 or 2527
# Use current repo context
```

### 2. Fetch MR Details

```bash
# View MR summary
glab mr view <MR_NUMBER>

# Get the diff
glab mr diff <MR_NUMBER>

# Check MR status and CI
glab mr view <MR_NUMBER> --comments
```

### 3. Review Checklist

For each file changed, check:

**Code Quality:**
- [ ] Code follows project conventions
- [ ] No obvious bugs or logic errors
- [ ] Error handling is appropriate
- [ ] No hardcoded secrets or credentials

**Ansible-Specific (for maglev-infra):**
- [ ] Tasks have appropriate names
- [ ] Tags are correctly applied
- [ ] Handlers are used appropriately
- [ ] Variables follow naming conventions
- [ ] No hardcoded paths that should be variables

**Security:**
- [ ] No credentials in code
- [ ] No command injection vulnerabilities
- [ ] Proper permissions on files
- [ ] No unsafe operations without safeguards

**Testing:**
- [ ] Changes have been tested in dev/stage
- [ ] Verification evidence in MR comments
- [ ] CI pipeline passes

### 4. Provide Review Feedback

After reviewing, provide:
1. Summary of what the MR does
2. List of files changed with brief description
3. Any concerns or suggestions
4. Overall assessment (approve/request changes)

### 5. Approve MR

If review passes:
```bash
# Approve the MR
glab mr approve <MR_NUMBER>

# Optionally add a comment
glab mr comment <MR_NUMBER> --message "LGTM! Reviewed and approved."
```

## Commands Reference

```bash
# View MR details
glab mr view 2527

# View MR diff
glab mr diff 2527

# View with comments
glab mr view 2527 --comments

# List MR files changed
glab api projects/:fullpath/merge_requests/2527/changes | jq '.changes[].new_path'

# Approve MR
glab mr approve 2527

# Add review comment
glab mr comment 2527 --message "Review comment here"

# Request changes (via comment)
glab mr comment 2527 --message "Requesting changes: <reason>"
```

## Example Usage

```
User: Review and approve MR 2527

Claude:
1. Fetches MR details with `glab mr view 2527`
2. Gets diff with `glab mr diff 2527`
3. Reviews each changed file
4. Provides summary:
   - 3 files changed
   - Adds deployment verification feature
   - Tests passed in dev/stage
   - No security concerns
5. Approves with `glab mr approve 2527`
```

## Safety Guardrails

Before approving, verify:
- [ ] You have read and understood all changes
- [ ] The MR has been tested (check comments for evidence)
- [ ] CI pipeline is passing
- [ ] No obvious security issues
- [ ] Changes match the stated intent

Never approve without reviewing the actual diff.

## Cross-Project MRs

For MRs in other projects:
```bash
# Specify repo explicitly
glab mr view 2527 --repo maglev-sre/maglev-infra
glab mr diff 2527 --repo maglev-sre/maglev-infra
glab mr approve 2527 --repo maglev-sre/maglev-infra
```
