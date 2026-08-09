# Variable Ownership Contract (Canonical)

This contract separates Workshop storage scope from module ownership. `globalvar` and
`playervar` describe how Overwatch stores a value; they do not decide which module is
responsible for that value.

### R-VAR-OWNERSHIP

Every declaration belongs to exactly one ownership category:

| Category | Owner boundary | Typical examples | Prelude status |
| --- | --- | --- | --- |
| `keep: infrastructure/shared protocol` | Cross-entry infrastructure or a stable public protocol used by unrelated modules | reset/init state, player identity, AI targeting, shared combat modifiers | Keep in `src/modules/prelude/*.opy` and record in the shared ABI baseline |
| `move: hero-owned global state/settings` | One hero's settings or global mechanic | a hero's Workshop-setting array | Declare under `src/heroes/<hero>/` |
| `move: hero-owned player state` | One hero's per-player implementation state | a hero AI gate or private runtime flag | Declare under the narrowest `src/heroes/<hero>/` module |
| `move: shared mechanic state` | A responsibility-named mechanic used by multiple heroes | burning stacks and lifecycle | Declare under a responsibility-named shared mechanic module |
| `defer: cross-module coupling must be resolved first` | A value whose consumers still depend on another module's storage layout | direct reads of another hero's private array | Keep its current declaration until a semantic interface or policy exists |

## Decision rules

1. Trace every read, write, reset, and lifecycle action through the expanded Main and
   ARAM include graphs before assigning an owner.
2. State used by one hero belongs to that hero, even when its Workshop storage scope is
   global or its reset path currently lives elsewhere.
3. State used by multiple heroes belongs to a responsibility-named mechanic module when
   those consumers share one gameplay responsibility. It does not remain in prelude only
   because it is a `playervar`.
4. Infrastructure and shared protocol state remains in prelude only when its consumers
   are genuinely cross-hero or cross-infrastructure and its ABI is intentionally public.
5. A direct cross-hero read of another hero's private storage is a blocker. Introduce a
   narrowly scoped semantic predicate or access policy before moving the storage.
6. Main-only and ARAM-only declarations may live in their mode-specific owner files.
   A declaration shared by both entries must be declared once in each entry's include
   closure, with the same logical name and an explicit stable slot when migration
   requires preserving the existing Workshop index.
7. Every module-local declaration must carry the repository's `#!mainFile` directive,
   be reachable from the entry that uses it, and be unique within that entry's expanded
   include graph.
8. New modules must use a responsibility-first name. Do not add generic `shared`,
   `common`, or catch-all variable buckets for convenience.

## Prelude ABI baseline

`tools/data/contract-guard/protocol-indexes.tsv` is the baseline for the declarations
that remain in the shared prelude protocol. It is not a registry of every `globalvar`
or `playervar` in the repository.

- A prelude declaration is part of the baseline only when it is classified as
  `keep: infrastructure/shared protocol`.
- A hero-private or mechanic-owned declaration must be removed from both prelude and
  the baseline when it is migrated.
- The relative order and explicit storage slots of the remaining baseline declarations
  must not change. A moved declaration may retain its old explicit slot in its owner
  module so that removing it from prelude does not renumber unrelated protocol state.
- Adding a new shared-prelude declaration requires an intentional baseline update and a
  separate review of its ABI impact.

## One-variable migration checklist

- [ ] Search the expanded Main and ARAM graphs for all reads, writes, reset paths, and
      lifecycle consumers.
- [ ] Assign exactly one category and record the current consumers and mode reach.
- [ ] Resolve direct cross-module storage reads or mark the variable `defer`.
- [ ] Choose the narrowest responsibility-named owner and add/verify `#!mainFile`.
- [ ] Move the declaration without changing its logical name or setting IDs.
- [ ] Preserve the old explicit slot when removing a declaration would shift shared
      protocol state.
- [ ] Remove migrated names from the prelude ABI baseline; never reorder the remaining
      entries to make a check pass.
- [ ] Run duplicate/include-graph checks, contract checks, Main and ARAM builds, and
      behavior-specific static checks before committing.

The Ana Biotic Grenade migration is the reference pattern. `Ana_GrenadeDamage` is
declared with its preserved slot in both `src/heroes/ana/settings.opy` and
`src/heroes/ana/settings.aram.opy`; `Ana_NanoHealAmp` is declared in the Main settings
module, and `nano_full_health` remains in the Main/ARAM rules modules. Their Workshop
setting IDs and values are unchanged. Burning and combat eligibility remain explicit
shared dependencies rather than ambient prelude state.
