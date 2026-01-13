---
name: ralph-wiggum
description: Self-critique loop that catches mistakes before finalizing - "I'm in danger" detection
tools:
  - Read
  - Grep
  - Bash
---

# Ralph Wiggum Self-Critique Loop

Named after the Simpsons character who says "I'm in danger" - this skill helps you recognize when you're about to make a mistake.

## When This Activates

Automatically engage self-critique when:
- You just wrote or modified code
- You're about to run a destructive command
- You made multiple changes in sequence
- The task seemed "too easy"
- You're uncertain about something

## The Ralph Loop

After completing any significant action, pause and ask:

### 1. Reality Check (Am I in Danger?)
```
□ Did I actually solve the problem, or just change something?
□ Did I read the error message carefully?
□ Am I making assumptions I haven't verified?
□ Does this "fix" match what I claimed I would do?
```

### 2. Obvious Mistakes Check
```
□ Syntax errors (missing brackets, typos)
□ Wrong file edited
□ Deleted something important
□ Hardcoded values that should be variables
□ Left debug code/print statements
□ Broke something that was working
```

### 3. Edge Case Scan
```
□ What if input is empty/null?
□ What if input is huge?
□ What if this runs twice?
□ What if network fails?
□ What happens on error?
```

### 4. Confidence Score

Rate yourself 1-10:
- **1-3**: I'm definitely wrong, let me start over
- **4-6**: Something feels off, let me verify
- **7-8**: Probably right, quick sanity check
- **9-10**: Confident, but verify anyway

### 5. Verification Action

Based on score, take action:

**Score 1-6**: Full review
```bash
# Run linter
ruff check path/to/file.py

# Run type checker
mypy path/to/file.py

# Run tests
pytest -x path/to/test_file.py

# Diff what changed
git diff path/to/file.py
```

**Score 7-8**: Quick check
```bash
# Just the linter
ruff check path/to/file.py --select=E,F

# Or syntax check
python -m py_compile path/to/file.py
```

**Score 9-10**: Minimal check
- Re-read the code once
- Ensure it matches the task

## Common "I'm in Danger" Signals

### Red Flags
- "This should work..." (but you haven't tested)
- Making the same fix for the third time
- The fix is longer than the original code
- You're not sure what the code does
- Copying code you don't understand

### Yellow Flags
- Task took much less time than expected
- You skipped reading the whole function
- You assumed the test coverage is good
- You're tired or distracted

## Example Ralph Loop

```
User: Fix the bug in calculate_total()

[After making change]

🔍 Ralph Check:
1. Reality: Did I fix the actual bug? Let me re-read the issue...
   - Issue was: negative numbers cause overflow
   - My fix: added abs() call
   - ⚠️ Wait, that changes the behavior for valid negatives!

2. Confidence: 4/10 - Something's wrong

3. Action: Let me reconsider...
   - The real fix should validate input, not silently change it
   - Adding: if value < 0: raise ValueError("...")

4. Re-check: Now confidence 8/10

5. Verify: Run tests... ✓ Pass
```

## Trigger Phrases

Say these to invoke Ralph mode:
- "ralph check" - Run full self-critique on last action
- "am I in danger?" - Quick reality check
- "let me verify" - Run verification commands
- "confidence check" - Rate and explain confidence level

## Integration with Adversarial Pipeline

Ralph is your internal critic. For external validation:
```
1. You make changes
2. Ralph checks your work (self-critique)
3. If Ralph passes → Send to Critic agent (external review)
4. If Critic finds issues → Fixer agent repairs
5. Verifier confirms
```

Ralph catches ~60% of issues before they reach the critic, saving cycles.
