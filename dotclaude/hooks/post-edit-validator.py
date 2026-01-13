#!/usr/bin/env python3
"""
Post-Edit Validation Hook

Triggered after Edit tool to run quick validation checks.
Returns feedback to Claude about potential issues.
"""

import json
import os
import subprocess
import sys
from pathlib import Path


def get_file_language(file_path: str) -> str | None:
    """Detect language from file extension."""
    ext_map = {
        ".py": "python",
        ".ts": "typescript",
        ".tsx": "typescript",
        ".js": "javascript",
        ".jsx": "javascript",
        ".go": "go",
        ".rs": "rust",
        ".sh": "shell",
        ".bash": "shell",
    }
    ext = Path(file_path).suffix.lower()
    return ext_map.get(ext)


def run_quick_check(file_path: str, language: str) -> list[str]:
    """Run quick validation for the given language."""
    issues = []

    if language == "python":
        # Syntax check
        result = subprocess.run(
            ["python", "-m", "py_compile", file_path],
            capture_output=True, text=True
        )
        if result.returncode != 0:
            issues.append(f"Python syntax error: {result.stderr.strip()}")

        # Quick ruff check (fast)
        try:
            result = subprocess.run(
                ["ruff", "check", "--select=E,F", "--output-format=concise", file_path],
                capture_output=True, text=True
            )
            if result.stdout.strip():
                for line in result.stdout.strip().split("\n")[:5]:  # Max 5 issues
                    issues.append(f"Ruff: {line}")
        except FileNotFoundError:
            pass

    elif language in ("typescript", "javascript"):
        # ESLint quick check
        try:
            result = subprocess.run(
                ["npx", "eslint", "--format=compact", file_path],
                capture_output=True, text=True
            )
            if result.stdout.strip():
                for line in result.stdout.strip().split("\n")[:5]:
                    issues.append(f"ESLint: {line}")
        except FileNotFoundError:
            pass

    elif language == "go":
        # Go vet
        try:
            result = subprocess.run(
                ["go", "vet", file_path],
                capture_output=True, text=True
            )
            if result.stderr.strip():
                issues.append(f"Go vet: {result.stderr.strip()}")
        except FileNotFoundError:
            pass

    elif language == "shell":
        # ShellCheck
        try:
            result = subprocess.run(
                ["shellcheck", "-f", "gcc", file_path],
                capture_output=True, text=True
            )
            if result.stdout.strip():
                for line in result.stdout.strip().split("\n")[:5]:
                    issues.append(f"ShellCheck: {line}")
        except FileNotFoundError:
            pass

    return issues


def main():
    """Main hook handler."""
    # Read hook input from stdin
    try:
        input_data = json.load(sys.stdin)
    except json.JSONDecodeError:
        sys.exit(0)  # No input, allow

    # Get the tool call info
    tool_name = input_data.get("tool_name", "")
    tool_input = input_data.get("tool_input", {})

    # Only process Edit tool
    if tool_name != "Edit":
        sys.exit(0)

    file_path = tool_input.get("file_path", "")
    if not file_path or not os.path.exists(file_path):
        sys.exit(0)

    # Detect language
    language = get_file_language(file_path)
    if not language:
        sys.exit(0)

    # Run quick validation
    issues = run_quick_check(file_path, language)

    if issues:
        # Return feedback (doesn't block, just informs)
        response = {
            "message": f"⚠️ Quick check found {len(issues)} potential issue(s):\n" + "\n".join(f"  • {i}" for i in issues),
        }
        print(json.dumps(response))
    else:
        # All good
        response = {
            "message": "✓ Quick check passed",
        }
        print(json.dumps(response))

    sys.exit(0)  # 0 = allow the edit


if __name__ == "__main__":
    main()
