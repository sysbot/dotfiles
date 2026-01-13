#!/usr/bin/env python3
"""
Agent State Tracker Hook

Tracks Claude agent state for the claude-status monitoring script.
- PreToolUse(AskUserQuestion): Sets state to "asking"
- UserPromptSubmit: Clears "asking" state (user responded)
- PostToolUse(AskUserQuestion): Records that question was displayed

State is stored per-session in ~/.claude/agent-state/
"""

import json
import os
import sys
from pathlib import Path
from datetime import datetime

STATE_DIR = Path.home() / ".claude" / "agent-state"


def ensure_state_dir():
    STATE_DIR.mkdir(parents=True, exist_ok=True)


def get_state_file(session_id: str) -> Path:
    return STATE_DIR / f"{session_id}.json"


def read_state(session_id: str) -> dict:
    state_file = get_state_file(session_id)
    if state_file.exists():
        try:
            return json.loads(state_file.read_text())
        except (json.JSONDecodeError, IOError):
            pass
    return {"state": "unknown", "updated": None}


def write_state(session_id: str, state: str, extra: dict = None):
    ensure_state_dir()
    state_file = get_state_file(session_id)

    # Preserve certain fields from existing state
    existing = read_state(session_id)
    project = existing.get("project")

    data = {
        "state": state,
        "updated": datetime.now().isoformat(),
        "session_id": session_id,
    }

    # Preserve project if it exists and not being overwritten
    if project and (not extra or "project" not in extra):
        data["project"] = project

    if extra:
        data.update(extra)
    state_file.write_text(json.dumps(data, indent=2))


def handle_pre_tool_use(hook_input: dict):
    """Called before AskUserQuestion - agent is about to ask."""
    session_id = hook_input.get("session_id", "unknown")
    tool_input = hook_input.get("tool_input", {})

    # Extract question info
    questions = tool_input.get("questions", [])
    question_text = questions[0].get("question", "") if questions else ""

    write_state(session_id, "asking", {
        "question": question_text[:100],  # Truncate for display
        "tool": "AskUserQuestion"
    })

    # Allow the tool to proceed
    return {"continue": True}


def handle_user_prompt_submit(hook_input: dict):
    """Called when user submits a prompt - they've responded."""
    session_id = hook_input.get("session_id", "unknown")

    # Clear asking state - user has responded
    write_state(session_id, "working", {
        "last_action": "user_response"
    })

    # Allow the prompt to proceed
    return {"continue": True}


def handle_notification(hook_input: dict):
    """Called on notifications - can detect idle/permission prompts."""
    session_id = hook_input.get("session_id", "unknown")
    notification_type = hook_input.get("notification_type", "")

    if notification_type == "idle_prompt":
        write_state(session_id, "idle")
    elif notification_type == "permission_prompt":
        write_state(session_id, "asking", {
            "question": "Permission required",
            "tool": "permission"
        })

    return {"continue": True}


def handle_session_start(hook_input: dict):
    """Called when session starts - initialize state."""
    session_id = hook_input.get("session_id", "unknown")
    source = hook_input.get("source", "startup")
    cwd = hook_input.get("cwd", "")

    write_state(session_id, "working", {
        "source": source,
        "project": os.path.basename(cwd) if cwd else "unknown"
    })

    return {"continue": True}


def handle_session_end(hook_input: dict):
    """Called when session ends - cleanup state."""
    session_id = hook_input.get("session_id", "unknown")

    # Remove state file
    state_file = get_state_file(session_id)
    if state_file.exists():
        state_file.unlink()

    return {"continue": True}


def handle_verification(hook_input: dict):
    """Called when verification starts/ends."""
    session_id = hook_input.get("session_id", "unknown")
    state = hook_input.get("state", "verifying")

    write_state(session_id, state, {
        "verification": True
    })

    return {"continue": True}


def main():
    # Read hook input from stdin
    try:
        hook_input = json.load(sys.stdin)
    except json.JSONDecodeError:
        # No input or invalid JSON - exit silently
        sys.exit(0)

    event = hook_input.get("hook_event_name", "")
    tool_name = hook_input.get("tool_name", "")

    result = None

    if event == "PreToolUse" and tool_name == "AskUserQuestion":
        result = handle_pre_tool_use(hook_input)
    elif event == "UserPromptSubmit":
        result = handle_user_prompt_submit(hook_input)
    elif event == "Notification":
        result = handle_notification(hook_input)
    elif event == "SessionStart":
        result = handle_session_start(hook_input)
    elif event == "SessionEnd":
        result = handle_session_end(hook_input)
    elif event == "Verification":
        result = handle_verification(hook_input)

    if result:
        print(json.dumps(result))

    sys.exit(0)


if __name__ == "__main__":
    main()
