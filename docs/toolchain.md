# Toolchain contract

This repository is currently a publication-held wider-matrix local tranche.

## Planned commands after promotion
- `stylua --check .`
- `luacheck .`
- `busted`

## Stability checks
- `python3 scripts/validate_scaffold.py`
- `nix run .#check` once `flake.lock` is generated for this repo

## Current limitation
- `nix` is installed locally, but `flake.lock` has not yet been generated in this repo.

## Validation notes
- Docker is the portable release gate for runtime promotion.
- The current docs/CI surface stays focused on publication-held stability until the repo gains runnable depth.
