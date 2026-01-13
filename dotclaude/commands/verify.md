# Verify Recent Work

Verify the recent changes made in this session by spawning a critic agent.

## Instructions

1. First, update the agent state to "verifying":
```bash
python ~/.claude/hooks/agent-state-tracker.py <<< '{"hook_event_name": "Verification", "session_id": "'$(cat ~/.claude/.session_id 2>/dev/null || echo "unknown")'", "state": "verifying"}'
```

2. Get the recent changes to verify:
   - Run `git diff HEAD~3` to see recent commits (or `git diff` for unstaged changes)
   - If no git repo, check recently modified files in the current directory

3. Launch a **critic** agent using the Task tool with `subagent_type: "critic"` to review the changes:
   - The critic should look for bugs, security issues, logic errors, and problems
   - The critic should be adversarial and thorough
   - Pass the diff output and relevant file contents to the critic

4. Report the critic's findings to the user:
   - Summarize any issues found
   - If issues are critical, offer to spawn a **fixer** agent to address them
   - If no issues found, confirm the work looks good

5. Update state back to "idle" when done

## Arguments

$ARGUMENTS - Optional: specific files or commits to verify (e.g., "src/auth.ts" or "HEAD~5")
