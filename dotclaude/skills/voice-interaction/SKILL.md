---
name: voice-interaction
description: Enable voice conversations with Claude Code - speak commands and hear responses
tools:
  - mcp__voice__voice_listen
  - mcp__voice__voice_speak
  - mcp__voice__voice_conversation
  - mcp__voice__voice_status
---

# Voice Interaction Mode

Speak to Claude Code and hear responses. Perfect for hands-free coding, accessibility, or when you're away from the keyboard.

## Quick Start

1. Check voice is working:
   ```
   Use voice_status tool
   ```

2. Listen to user:
   ```
   Use voice_listen with duration=5
   ```

3. Speak response:
   ```
   Use voice_speak with text="Hello, I heard you!"
   ```

## Voice Conversation Flow

When in voice mode, follow this pattern:

```
1. Speak a prompt/question to user
2. Listen for their response
3. Process what they said
4. Speak your response
5. Repeat
```

### Example Conversation

```
Claude: voice_speak("What would you like me to help with?")
Claude: voice_listen(duration=10)
→ User said: "Can you find all the TODO comments in my code?"
Claude: [runs grep for TODOs]
Claude: voice_speak("I found 5 TODO comments. The first one is in main.py line 42 about fixing the database connection.")
```

## Commands via Voice

Users can say things like:
- "Search for [pattern] in [file/directory]"
- "Open [filename]"
- "Run the tests"
- "Fix the error in [file]"
- "What does [function name] do?"
- "Commit these changes with message [message]"
- "Stop" or "Cancel" or "Never mind"

## Voice Response Guidelines

When speaking responses:

### DO
- Keep responses concise (< 30 seconds of speech)
- Summarize long outputs ("Found 15 files, the most relevant are...")
- Confirm actions before running them
- Ask clarifying questions for ambiguous requests
- Spell out unusual names/symbols

### DON'T
- Read entire file contents aloud
- Speak raw error messages (summarize them)
- Give long explanations (offer to show on screen instead)
- Assume - ask if unclear

## Handling Voice Commands

Parse user speech and map to actions:

| User Says | Action |
|-----------|--------|
| "search for X" | Grep for X |
| "find file X" | Glob for X |
| "read/open/show X" | Read file X |
| "edit/change/fix X" | Edit file X |
| "run tests" | Bash: pytest/npm test |
| "run/execute X" | Bash: X |
| "commit X" | Git commit with message X |
| "what/explain X" | Describe X |
| "help" | List available commands |
| "stop/cancel/quit" | Exit voice mode |

## Error Handling

If transcription is unclear:
```
voice_speak("I didn't catch that. Could you repeat?")
voice_listen(duration=10)
```

If command is ambiguous:
```
voice_speak("Did you mean X or Y?")
voice_listen(duration=5)
```

## Voice Settings

Control voice behavior via environment variables:
```bash
# Whisper model size (tiny/base/small/medium/large)
export WHISPER_MODEL=base

# Default recording duration
export VOICE_DURATION=5
```

## Accessibility Notes

Voice mode is designed for:
- Hands-free operation
- Screen reader compatibility
- Reduced visual dependency

When voice is active, also output text for screen readers.

## Troubleshooting

### "No audio available"
```bash
pip install sounddevice numpy
```

### "Whisper not found"
```bash
pip install openai-whisper
```

### "No TTS on Linux"
```bash
pip install pyttsx3
```

### Poor transcription
- Speak clearly, closer to microphone
- Reduce background noise
- Try longer duration
- Use larger Whisper model: `export WHISPER_MODEL=small`
