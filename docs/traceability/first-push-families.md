# First-push family traceability

This repo is a publication-held wider-matrix local tranche. The rows below record the current classic-six and modern-core contract surface that should remain traceable back to Rust and `stakeholder-core` as implementation depth is added.

## Traceability rows

| Family | Parity class | Upstream/source anchor | Contract anchor | Repo-local status |
|---|---|---|---|---|
| `code_analyzer` | classic-six | `rust-stakeholder/src/generators/` | `stakeholder-core/docs/program/rewrite-status-matrix.md` | publication-held local tranche |
| `data_processing` | classic-six | `rust-stakeholder/src/generators/` | `stakeholder-core/docs/program/current-wave.md` | publication-held local tranche |
| `jargon` | classic-six | `rust-stakeholder/src/generators/` | `stakeholder-core/docs/program/current-wave.md` | publication-held local tranche |
| `metrics` | classic-six | `rust-stakeholder/src/generators/` | `stakeholder-core/docs/program/rewrite-status-matrix.md` | publication-held local tranche |
| `network_activity` | classic-six | `rust-stakeholder/src/generators/` | `stakeholder-core/docs/program/rewrite-status-matrix.md` | publication-held local tranche |
| `system_monitoring` | classic-six | `rust-stakeholder/src/generators/` | `stakeholder-core/docs/program/current-wave.md` | publication-held local tranche |
| `agent_workflows` | modern-core | `rust-stakeholder/src/generators/` | `stakeholder-core/docs/program/current-wave.md` | publication-held local tranche |
| `platform_engineering` | modern-core | `rust-stakeholder/src/generators/` | `stakeholder-core/docs/program/rewrite-status-matrix.md` | publication-held local tranche |
| `observability_ai_runtime` | modern-core | `rust-stakeholder/src/generators/` | `stakeholder-core/docs/program/current-wave.md` | publication-held local tranche |
| `delivery_preview_ops` | modern-core | `rust-stakeholder/src/generators/` | `stakeholder-core/docs/program/rewrite-status-matrix.md` | publication-held local tranche |
| `supply_chain_security` | modern-core | `rust-stakeholder/src/generators/` | `stakeholder-core/docs/program/current-wave.md` | publication-held local tranche |

## Open gap row

| Gap | Parity class | Upstream/source anchor | Contract anchor | Repo-local status |
|---|---|---|---|---|
| `live-provider-runtime` | eventual full program lane | `rust-stakeholder/src/experimental.rs`, `java-stakeholder/src/main/java/com/stakeholder/experimental/ExperimentalRuntime.java`, `javascript-stakeholder/src/server/providers/index.js` | `stakeholder-core/docs/program/current-wave.md` | open gap in the wider program |

## Notes

- Traceability remains explicit even though this repo is publication-held.
- No runtime/source/test files are touched by this documentation tranche.
