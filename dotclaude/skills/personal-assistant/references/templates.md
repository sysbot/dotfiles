# Org-Capture Templates Reference

Complete reference for the user's org-capture templates.

## Task Templates

### `t` - Quick Task
- **File**: ~/org/inbox.org
- **Format**: `* TODO {Task}`
- **Properties**: CREATED timestamp
- **Behavior**: Immediate finish (no editing)

### `T` - Full Task
- **File**: ~/org/inbox.org
- **Format**: `* TODO {Task}`
- **Properties**: CREATED timestamp
- **Behavior**: Opens for editing

### `.` - Today Task
- **File**: ~/org/inbox.org
- **Format**: `* TODO {Task}` with `SCHEDULED: <today>`
- **Behavior**: Immediate finish

### `e` - Errand
- **File**: ~/org/inbox.org
- **Format**: `* TODO {Task} :errands:`
- **Behavior**: Immediate finish

### `i` - Interrupted Task
- **File**: ~/org/inbox.org
- **Format**: `* STARTED {Task}`
- **Behavior**: Clocks in, resumes on finish

### `b` - Business Task
- **File**: ~/org/business.org → Tasks
- **Format**: Full template with effort estimation
- **Effort options**: 0:05, 0:15, 0:30, 1:00, 2:00, 3:00, 4:00

## Note Templates

### `n` - Quick Note
- **File**: ~/org/inbox.org
- **Format**: `* {Note}`
- **Properties**: CREATED timestamp
- **Behavior**: Immediate finish

### `r` - Note with Reference
- **File**: ~/org/inbox.org
- **Format**: `* {Note}` with link back to source
- **Behavior**: Opens for editing

### `j` - Journal Entry
- **File**: ~/org/journal.org (datetree)
- **Format**: Plain text with timestamp
- **Behavior**: Opens for editing

## Web Capture Templates

### `p` - Protocol (Full Capture)
- **File**: ~/org/inbox.org → Web Captures
- **Format**: Title, quote block, link
- **Use**: Capturing selected text from browser

### `L` - Protocol Link
- **File**: ~/org/inbox.org → Links
- **Format**: `* [[url][title]]`
- **Behavior**: Immediate finish
- **Use**: Quick link saving

### `W` - Web Bookmark
- **File**: ~/org/bookmarks.org → Unsorted
- **Format**: Link with CREATED property
- **Behavior**: Opens for editing

## Special Templates

### `B` - Book
- **File**: ~/org/books.org (datetree)
- **Format**: Title, author, review date
- **Behavior**: Clocks in

### `C` - Contact
- **File**: ~/org/contacts.org
- **Format**: Name, EMAIL property
- **Behavior**: Auto-extracts from email if in Gnus

### `l` - Ledger (submenu)
- `lc` - Cash expense
- `lb` - Chase USD
- `lp` - Coinbase ETH

### `db`/`dp` - Done Tasks
- Pre-filled as DONE with scheduled date prompt

## TODO Keywords

Sequence: `TODO` → `FEEDBACK` → `VERIFY` → `|` → `DONE` / `DELEGATED`

## Tags (with quick keys)

- work (w), home (h), errands (e), biz (d)
- idea (c), video (v), book (b), kaizen (k)
- reading (r), computer (l), quantified (q), focus (f)

## Emacsclient Commands

To trigger capture programmatically:

```bash
# Quick task
emacsclient -e '(org-capture nil "t")'

# With content
emacsclient -e '(let ((org-capture-initial "My task content")) (org-capture nil "T"))'
```
