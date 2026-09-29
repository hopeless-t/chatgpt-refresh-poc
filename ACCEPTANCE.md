# Acceptance matrix

| Case | Expected result |
| --- | --- |
| Server revision is newer | Replace server-backed snapshot |
| Server revision is equal | No-op |
| Server revision is older | No-op |
| Conversation ID differs | Reject/no-op |
| User has unsent draft | Preserve draft |
| User has scroll anchor | Preserve anchor where possible |
| Local stream/UI state exists | Preserve local-only UI state |
| Refresh repeated at same revision | Idempotent no-op |
| Fetch fails | Keep current conversation intact |
| Refresh is tapped during generation | Observe/reconcile only; do not replay or grant execution authority |

## Forbidden effects

A refresh operation must not:

- send a user message;
- regenerate an assistant response;
- start a tool call;
- create a new conversation;
- create a branch;
- discard unsent text;
- roll back to older server-backed state.
