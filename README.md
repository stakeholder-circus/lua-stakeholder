> [!IMPORTANT]
> This repository is part of a Codex-assisted rewrite experiment. All changes are manually reviewed, a human remains in the loop, and missing behavior is tracked explicitly rather than hidden. The project exists for fun, research, language learning, AI agent workflow/planning, interop experiments, and code review testing.
# lua-stakeholder

Lua scaffold under `stakeholder-circus`.

## Status
- Scaffold-only repository.
- Imported Rust history is preserved for attribution and auditability.
- Governance, provenance, hook, and CI baselines are in place.
- No parity-depth claims are made until this repo is explicitly promoted from the scaffold queue.

## Role
- Embeddable full-parity scaffold.
- Purpose: Lightweight embeddable scripting lane that will still carry a full scheduler, renderer, and event-model implementation without delegating generation back to Rust.
- Program category: embeddability, interop

## Planned toolchain contract
- `stylua --check .`
- `luacheck .`
- `busted`

## Current guardrail
- This repo is intentionally limited to scaffold readiness. Real implementation depth begins only after promotion from the wider matrix queue.

## Documentation
- [AI disclosure](AI_DISCLOSURE.md)
- [Parity](PARITY.md)
- [Explicit gaps](GAPS.md)
- [Remotes](docs/remotes.md)
- [Provenance](docs/provenance.md)
- [Toolchain](docs/toolchain.md)
