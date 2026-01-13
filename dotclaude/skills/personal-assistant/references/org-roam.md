# Org-Roam Knowledge Base Reference

The user's knowledge base with 400+ interconnected notes.

## Directory Structure

```
~/org/roam/
├── daily/           # Daily notes
├── references/      # Reference materials
├── projects/        # Project notes
├── meetings/        # Meeting notes
└── *.org           # General notes
```

## Roam Capture Templates

### `d` - Default Note
- Creates timestamped file: `YYYYMMDDHHMMSS-slug.org`
- Tags: `:default:`
- Plain content

### `r` - Reference Note
- Location: `references/` subdirectory
- Sections: Source, Summary, Notes
- Tags: `:reference:`

### `p` - Project Note
- Location: `projects/` subdirectory
- Sections: Goals, Tasks, Notes
- Tags: `:project:`

### `m` - Meeting Note
- Location: `meetings/` subdirectory
- Sections: Attendees, Agenda, Notes, Action Items
- Tags: `:meeting:`
- Includes date

## Daily Notes

- Directory: `daily/`
- Format: `YYYY-MM-DD.org`
- Sections: Morning Review, Tasks, Notes, Evening Review
- Tags: `:daily:`

## Searching Roam

### By Title
```elisp
(org-roam-node-find)  ; Interactive search
```

### By Content
Use Deft (bound to `C-c n d`) for full-text search across roam directory.

### By Tag
```elisp
(org-roam-node-find nil nil (lambda (node)
  (member "project" (org-roam-node-tags node))))
```

## Creating Notes

### Via Emacsclient
```bash
# Create with specific template
emacsclient -e '(org-roam-capture- :keys "d")'

# Find or create
emacsclient -e '(org-roam-node-find)'
```

### Linking Notes
- `[[roam:Note Title]]` - Link by title
- Auto-completion available everywhere

## Common Topics in Knowledge Base

Based on directory structure:
- Technical: CI, performance, databases, infrastructure
- Business: NVIDIA, Skye Labs, various ventures
- Personal: Family, home projects, hobbies
- Projects: Ham radio, telescope, farming

## Integration with Agenda

Roam notes can contain TODOs that appear in agenda if:
1. File is in `org-agenda-files`
2. Or use org-roam-agenda to include roam TODOs
