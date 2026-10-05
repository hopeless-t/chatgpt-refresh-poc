# Refresh as a durable-work re-observation primitive

Status: semantic note only; no private API assumption

Source intake: https://note.com/npaka/n/n341b20a052c6

The durable-agent discussion strengthens the reason to keep `Refresh Conversation` narrow.

A long-lived Commitment that references a conversation does not need permission to regenerate, resend, or branch when it wakes. It first needs a safe way to **re-observe current canonical server state**.

```text
wake / resume
  -> refresh observation
  -> validate same conversation + monotonic revision
  -> reconcile local projection
  -> only a separate authority path may propose mutation
```

Useful boundaries:

```text
Wakeup != Regenerate
Resume != Resend
Refresh != Retry
Refresh != Canonical Mutation
Newer Observation != Permission To Act
```

This makes the PoC a small reusable example of a larger systems law:

> When a durable workflow resumes after uncertainty or process death, the first primitive should often be idempotent re-observation rather than re-execution.

No implementation change is proposed here; the existing refresh contract already provides the desired read-only semantic shape.