# Cubacadabra Second Game: Signal Run

This is the second-game variant of the portable Cubacadabra package. It keeps
the shared multiplayer build host, but changes the test identity and play
space so it is easy to tell apart from `first-game`:

- a dark indigo, orange, violet, and cyan palette replaces the first game's
  sea-glass palette
- the lobby is a `Signal Station`, with a `DROP SIGNAL` launch pad
- the session is a collision-heavy `Relay Yard` with beacon towers and a
  zig-zag route
- the Luau UI calls the mode `SIGNAL RUN`, starts on beam/violet selections,
  and reports beacon progress as players place, rotate, or remove blocks

Build the runtime package from this directory with:

```sh
cubacadabra build-game . --output build/package
```
