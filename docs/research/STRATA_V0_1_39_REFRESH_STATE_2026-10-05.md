# Strata v0.1.39 cross-pollination for chatgpt-refresh-poc — 2026-10-05

## Useful transfer

Treat refresh/resume state as a tiered working set rather than replaying everything indiscriminately.

## Candidate model

- **hot:** exact minimal state needed to continue the current operation;
- **warm:** recent checkpoints, compact tool/result state and likely-next context;
- **cold:** full history/event log, addressable on demand.

Budget by bytes/tokens and resume utility, not turn count.

## Experiments

1. Fixed last-N turns vs byte-budgeted resume set.
2. Static resume set vs adaptive promotion from recent access/reuse.
3. Bulk refresh/reconstruction policy vs steady interactive policy.
4. One refresh at a time vs concurrent refresh admission under limited context/memory.
5. Explicit degraded resume lane when complete state is unavailable, with missingness surfaced rather than guessed.

## Correctness gate

Candidate reconstructed state may be generated cheaply, but acceptance should compare exact checkpoint IDs/hashes/postconditions wherever available.

## Boundary

Refresh success != semantic equivalence unless required state is verified.
