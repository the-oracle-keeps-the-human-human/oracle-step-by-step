# Project Maintenance Vault

This `psi/` directory is for maintaining the `oracle-step-by-step` repository.
It is not part of the Oracle workspace that this guide helps users create.

The guide still teaches users to create their own Oracle brain vault. This
maintainer vault records work on this teaching repo: handoffs, decisions,
readouts, and project-specific learnings.

## Rules

- GitHub Issues and pull requests are the durable queue.
- This vault is memory and handoff, not a task claim system.
- Do not store secrets, tokens, API keys, generated databases, or runtime state.
- Keep user-facing setup instructions in `README.md` and `steps/`.
- Use this vault only for project maintenance context.

## Structure

```text
psi/
  active/     current maintainer context and checkpoints
  handoff/    session handoffs for future maintainers
  decisions/  project decisions, reversals, and rationale
  learn/      repo readouts, proofs, and investigations
  memory/     durable project learnings and retrospectives
```
