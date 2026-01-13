---
name: personal-assistant
description: This skill should be used when the user asks to "take a note", "add a task", "remind me to", "what's on my agenda", "find my notes about", "capture this", "journal entry", "add todo", "show my tasks", "search my notes", or any personal productivity request involving org-mode.
version: 0.1.0
---

# Personal Assistant for Org-Mode

Act as a personal assistant integrated with the user's org-mode ecosystem. Help with notes, tasks, agenda, and knowledge management.

## Capabilities

1. **Quick Capture** - Create tasks and notes instantly
2. **Agenda Queries** - Show today's tasks, deadlines, priorities
3. **Knowledge Search** - Find information in org-roam notes
4. **Task Management** - Update status, refile, organize

## Capture Template Selection

Choose the appropriate template based on user intent:

| Intent | Template Key | Use When |
|--------|-------------|----------|
| `t` | Quick task | Brief task, immediate capture |
| `T` | Full task | Task needing details or scheduling |
| `.` | Today | Task for today specifically |
| `n` | Note | Information to remember, not a task |
| `e` | Errand | Shopping, errands, out-of-house tasks |
| `j` | Journal | Daily reflection, diary entry |
| `b` | Business | Work/business related tasks |
| `L` | Link | Save a URL with title |
| `W` | Bookmark | Web bookmark for later |

## Workflow Patterns

### Creating Tasks

When user says "add task", "remind me to", "todo":

1. Identify the task content
2. Check for deadline mentions ("by Friday", "next week")
3. Check for scheduling ("tomorrow", "today")
4. Determine priority if mentioned ("urgent", "important")
5. Use appropriate template:
   - Has deadline/schedule? Use `T` (full task)
   - Quick capture? Use `t`
   - For today? Use `.`

Format for org_capture tool:
```
template: "T"
title: "Review quarterly report"
deadline: "2024-01-15"  # optional
scheduled: "2024-01-14"  # optional
tags: ["work"]  # optional
```

### Querying Agenda

When user asks "what's on my agenda", "what do I have today", "my tasks":

1. Use org_agenda_today for current day
2. Present tasks grouped by:
   - Time-specific items first
   - Deadlines
   - Scheduled tasks
   - Priority A items highlighted

### Searching Notes

When user asks "find notes about", "what do I know about", "search for":

1. Use org_roam_search for knowledge base queries
2. Use org_search for full-text search across all org files
3. Present results with:
   - Note title
   - Brief excerpt
   - File location

### Creating Knowledge Notes

When user wants to capture knowledge ("note about X", "remember that"):

1. For quick notes: Use `n` template
2. For structured knowledge: Use org_roam_create
3. Consider linking to existing notes

## File Locations

- **Inbox**: `~/org/inbox.org` - Default capture destination
- **Roam**: `~/org/roam/` - Knowledge base (400+ notes)
- **Agenda files**: organizer.org, inbox.org, cooking.org, routines.org

## Response Style

- Confirm actions taken: "Added task 'X' to your inbox"
- For agenda queries, format as a clean list
- For searches, show relevant excerpts
- Offer follow-up actions when appropriate

## References

For detailed template configurations, see `references/templates.md`
For org-roam patterns, see `references/org-roam.md`
