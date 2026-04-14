> [!NOTE]
> Missing or deferred behavior must fail fast and be tracked explicitly. No placeholder behavior should mask absent parity work.

# Lua Gaps

## Current explicit gaps
- `lua-stakeholder.live-provider-runtime-pending`: the eventual full live-provider lane remains open and must fail fast until implemented.
- `lua-stakeholder.post-modern-core-pending`: later packet families remain open in the publication-held wider program.
- `lua-stakeholder.traceability-publication-pending`: this repo documents its current publication-held tranche in `docs/traceability/first-push-families.md`, but future runtime promotion will still need concrete source-level rows.
- `lua-stakeholder.codeql-activation-pending`: CodeQL activation is deferred until the repo contains source-bearing implementation files in a supported language.
- `lua-stakeholder.flake-lock-not-generated`: `nix` is installed locally, but `flake.lock` has not yet been generated in this repo.
- `lua-stakeholder.docker-first-release-gate-pending`: Docker remains the portable release gate for the next runtime promotion step.

## Guardrail
- Do not present this publication-held local tranche as implementation-complete live-provider parity.
