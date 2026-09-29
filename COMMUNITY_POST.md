# Ready-to-post community note

## Title

[iOS] Explicit “Refresh Conversation” action for read-only resync

## Body

I’d like to propose an explicit **Refresh Conversation** action in the ChatGPT iOS app.

The use case is narrow: when the server-side conversation has advanced but the currently open iOS view remains stale, the user should be able to re-fetch and reconcile the latest conversation state without force-quitting the app.

Suggested contract:

- fetch the latest state for the currently open conversation;
- no-op when the server has no newer revision;
- reconcile newer server-backed messages into the visible conversation;
- preserve unsent draft text and scroll position where possible;
- never send, regenerate, branch, or create a new conversation;
- never let an older response overwrite newer state;
- treat the operation as **observation/reconciliation only**, with no generation or tool-execution authority.

In short:

```text
Refresh = Observe + Reconcile + Render
Refresh ≠ Regenerate
Refresh ≠ Send
Refresh ≠ New Chat
```

I made a small Swift proof-of-concept that models the behavior contract without using private ChatGPT APIs:

https://github.com/hopeless-t/chatgpt-refresh-poc

The PoC includes acceptance tests for newer revision application, stale revision no-op behavior, identity mismatch rejection, and preservation of local-only UI state.
