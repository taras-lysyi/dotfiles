---
description: Write a QA testing summary for given ticket
---
Write QA testing summary for ticket `${@:1}`.

Inputs:
- Treat `${@:1}` as Jira ticket key (e.g. `PROJ-123`). If empty, stop and ask for ticket key.

Tools:
- `jira issue view <KEY> --plain` to read ticket body.
- `jira issue view <KEY> --raw | jq '.fields.comment.comments'` to fetch all comments.
- `gh pr list --search "<KEY>" --state all --limit 20 --json number,title,url,headRepository,state` to find related PRs (UI + BE). PR title should contain ticket key.
- `gh pr view <NUMBER> --repo <OWNER/REPO>` and `gh pr diff <NUMBER> --repo <OWNER/REPO>` to read PR changes.
- `jira issue comment add <KEY> --template -` (pipe body via stdin) to post comment.

Steps:
1. Read Jira ticket via `jira issue view`. Extract feature title and acceptance criteria.
2. List PRs matching ticket key. Identify which is UI and which is BE by repo/title.
3. For each PR, read description and diff. Focus on business logic, not implementation details.
4. Compose comment using template below and post via `jira issue comment add <KEY> --template -`.

Comment template:
```markdown
# QA Testing Summary - <feature-title>

## What changed:
Short summaries for UI and BE changes if exist.
Focus on business logic rather than implementation details.

## Test cases:
Two-column table: scenario, expected result.

## Edge cases:
Bullet list of edge cases.

## Notes:
Bullet list of additional notes useful for QA to understand feature scope.
```

Output rules:
- Before posting, print final comment body for review.
- Confirm post succeeded by echoing comment URL or `jira` CLI output.
- If PRs not found, say so plainly and skip post.
