# Variable Ownership Contract (Canonical)

This contract separates Workshop storage scope from module ownership. `globalvar` and
`playervar` describe how Overwatch stores a value; they do not decide which module is
responsible for that value.

The current declaration inventory and ordered migration waves are tracked in
`docs/agents/variable-ownership-matrix.md`.

### R-VAR-OWNERSHIP

Every declaration belongs to exactly one ownership category:

| Category | Owner boundary | Typical examples | Prelude status |
| --- | --- | --- | --- |
| `keep: infrastructure/shared protocol` | Cross-entry infrastructure or a stable public protocol used by unrelated modules | reset/init state, player identity, AI targeting, shared combat modifiers | Keep in `src/modules/prelude/*.opy` |
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
   closure, with the same logical name.
7. Every module-local declaration must carry the repository's `#!mainFile` directive,
   be reachable from the entry that uses it, and be unique within that entry's expanded
   include graph.
8. New modules must use a responsibility-first name. Do not add generic `shared`,
   `common`, or catch-all variable buckets for convenience.

## One-variable migration checklist

- [ ] Search the expanded Main and ARAM graphs for all reads, writes, reset paths, and
      lifecycle consumers.
- [ ] Assign exactly one category and record the current consumers and mode reach.
- [ ] Resolve direct cross-module storage reads or mark the variable `defer`.
- [ ] Choose the narrowest responsibility-named owner and add/verify `#!mainFile`.
- [ ] Move the declaration without changing its logical name or setting IDs.
- [ ] Run duplicate/include-graph checks, contract checks, Main and ARAM builds, and
      behavior-specific static checks before committing.

The Ana Biotic Grenade migration is the reference pattern. `Ana_GrenadeDamage` is
declared in both `src/heroes/ana/settings.opy` and
`src/heroes/ana/settings.aram.opy`; `Ana_NanoHealAmp` is declared in the Main settings
module, and `nano_full_health` remains in the Main/ARAM rules modules. Their Workshop
setting IDs and values are unchanged. Burning and combat eligibility remain explicit
shared dependencies rather than ambient prelude state.

### Domina player-state pilot audit

The current source has no declaration, read, write, or reset path for
`domina_ai_busy` or `domina_secondary_retry_blocked`. Those names belonged to the
reverted Domina AI serialization change tracked by #61. The ownership refactor does
not reintroduce that behavior; if a future Domina implementation adds either state,
the declaration must live in the narrowest `src/heroes/domina/` module and be covered
by the same Main/ARAM uniqueness checks.

### Burning mechanic owner audit

The branch has no active `burn_stack` readers or writers after the burn-stack behavior
was retired, so the unused declaration and owner module were removed. Future burning
consumers must declare state only when an active responsibility-named mechanic requires
it, instead of restoring ambient prelude state.

### Combat-policy pilot audit

`src/modules/combat-policy/custom-effect-guards.opy` exposes
`Player.blocksCustomDot()` for the exact custom-DOT protection decision previously
encoded in Ana's rule. Its implementation retains the existing
`zarya_buff[1] != null` behavior, while Ana no longer reads that storage directly.
The existing `INVINCIBLE`/`PHASED_OUT` and `has_nano` conditions remain separate and
are mechanically checked with the policy call.

The following direct `zarya_buff` consumers remain deferred because their surrounding
semantics are not the same custom-DOT policy: Freja's knockback threshold, Genji's
execution threshold, Shion's damage threshold, Sojourn's damage threshold, Orisa's
own protection state, Roadhog's execution, and Hazard's direct damage. Zarya's own
initialization and lifecycle writes remain hero-owned storage internals.
