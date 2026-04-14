> [!IMPORTANT]
> This repository is part of a Codex-assisted rewrite experiment. All changes are manually reviewed, a human remains in the loop, and missing behavior is tracked explicitly rather than hidden. The project exists for fun, research, language learning, AI agent workflow/planning, interop experiments, and code review testing.
# lua-stakeholder

Validated wider-matrix local tranche under `stakeholder-circus`.

## Status
- Publication-held wider-matrix local tranche.
- Imported Rust history is preserved for attribution and auditability.
- Governance, provenance, hook, and CI baselines are in place.
- Classic-six and modern-core depth is tracked explicitly, while live-provider runtime remains an open program gap.
- No parity-depth claims are made beyond the publication-held local tranche.

## Role
- Embeddable full-parity lane.
- Purpose: Lightweight embeddable scripting lane that carries deterministic scheduler, renderer, and event-model behavior locally, with live-provider runtime still open for the eventual full program target.
- Program category: embeddability, interop

## Planned toolchain contract
- `stylua --check .`
- `luacheck .`
- `busted`
- Docker is the release gate for future runtime promotion.

## Current guardrail
- This repo is publication-held. Live-provider runtime and later packet families remain open gaps in the wider program.

## Documentation
- [AI disclosure](AI_DISCLOSURE.md)
- [Parity](PARITY.md)
- [Explicit gaps](GAPS.md)
- [Remotes](docs/remotes.md)
- [Provenance](docs/provenance.md)
- [Toolchain](docs/toolchain.md)
- [Traceability](docs/traceability/first-push-families.md)
