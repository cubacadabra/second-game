# Cubacadabra Second Game: Signal Run

Signal Run is a cooperative relay/obstacle game built from the same generic
runtime APIs as Spellbound Schoolyard. Players weave through four ordered
signal gates, then sprint to a shared uplink and trigger overdrive.

The game demonstrates that a package can supply a different:

- world layout and movement pattern
- authoritative state schema and reducer
- interaction-state visual language
- effect library and audio identity
- compact in-game HUD

No Signal Run rules or names live in Rust or the backend.

## Source

- `manifest.json` — package identity, audio, world, and interactions
- `effects.json` — relay gates, uplink states, and one-shot bursts
- `src/relay.luau` — ordered relay reducer and accepted-state feedback
- `src/main.luau` — portable lifecycle entry point
- `src/ui/` — game-owned HUD

`src/main.luau` explicitly includes
`@cubacadabra/shared-state-v1.luau` and
`@cubacadabra/disclosure-v1.luau`. The shared helpers handle bounded intent
queuing and generic tap-to-reveal state. Signal Run owns every state field,
transition, HUD label, and edge placement. Its persistent HUD is a compact
top-right race counter; the route detail appears only when a player taps it.

## Build

```sh
PYTHONPATH=../tools/src python3 -m cubacadabra build-game . \
  --output build/package --zip build/second-game-v0.3.0.zip
```

The builder inlines `effects.json` into the generated manifest, so runtime
clients still receive one portable package without source-file dependencies.

### Licensing

Copyright (C) 2026 Andrew Arrow

Licensed under the GNU General Public License v3.0 or later.
See [LICENSE](LICENSE).
