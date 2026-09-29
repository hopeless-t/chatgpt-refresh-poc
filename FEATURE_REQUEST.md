# Feature request: explicit “Refresh Conversation” on iOS

## Problem

When a conversation's server-side state has advanced but the iOS client remains visually stale, the user may need to terminate and relaunch the app just to see the latest conversation state. A dedicated refresh action would make that recovery explicit and much less disruptive.

## Proposed behavior

Add a `Refresh Conversation` action to the currently open conversation. Its contract should be **read-only synchronization**, not generation.

### Acceptance criteria

1. Refresh fetches the latest server state for the currently open conversation.
2. If the server has no newer state, refresh is a no-op.
3. If a newer state exists, the visible message tree is reconciled to it.
4. Unsent draft text is preserved.
5. Scroll position is preserved where possible.
6. Repeating refresh against the same server revision is idempotent.
7. An older/stale server response must never overwrite newer local/server-backed state.
8. Refresh must not send a message, regenerate a response, create a new chat, or create a branch.
9. If a generation/tool run is active, refresh may update observable server state but must not grant or replay execution authority.
10. Errors should leave the existing conversation intact and expose a retryable, non-destructive failure state.

## Suggested UI

A standard `arrow.clockwise` action in the conversation menu is sufficient. Pull-to-refresh could be an additional gesture later, but an explicit action is easier to discover and safer to specify first.

## Suggested semantic model

```text
Refresh = Observe + Reconcile + Render
Refresh ≠ Regenerate
Refresh ≠ Send
Refresh ≠ New Chat
```

The key property is that refresh has **observation authority only**. It can update the local projection from canonical server state, but it cannot initiate a new model/tool action.

## Reference PoC

The accompanying Swift package demonstrates revision-gated, idempotent refresh while preserving local-only UI state. It deliberately avoids private APIs and models only the behavior contract.
