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
`@cubacadabra/shared-state-v1.luau`. The shared helper handles bounded intent
queuing, compare-and-set conflicts, retries, and reconnect snapshots. Signal
Run continues to own every state field and transition.

## Build

```sh
PYTHONPATH=../tools/src python3 -m cubacadabra build-game . \
  --output build/package --zip build/second-game-v0.0.1.zip
```

The builder inlines `effects.json` into the generated manifest, so runtime
clients still receive one portable package without source-file dependencies.
