# contain — developer notes

## Spec system

Specs live under `specs/` in a nested parent/child hierarchy. Each spec node has:

- `definition/` — the spec's own files (Containerfile, init.sh, run.dbus, etc.)
- `children/` — child specs that build FROM this spec's image

A spec tag like `ubuntu/firefox` maps to:
- Directory: `specs/ubuntu/children/firefox/definition/`
- Image: `localhost/contain:ubuntu--firefox`
- BASE build-arg: `localhost/contain:ubuntu` (auto-built if missing)

Arbitrary depth is supported: `a/b/c` → `specs/a/children/b/children/c/definition/`, tag `localhost/contain:a--b--c`.

## Scripts

**`build <spec-tag>`** — resolves the spec dir, derives TAG and BASE from the path, auto-builds the parent if missing, then runs `podman build`.

**`contain <spec-tag>`** — resolves the spec dir and image tag the same way, starts socket proxies (Wayland, PipeWire, PulseAudio, D-Bus), mounts the persistent home at `~/.local/share/contain/<instance>/`, and runs the container.

Both scripts share the same `spec_dir()` function logic (path segments interleaved with `children/`, `definition/` suffix).

## Adding a new spec

1. Create `specs/<parent>/children/<name>/definition/Containerfile` — use `ARG BASE` / `FROM $BASE`
2. Add `run.dbus` (D-Bus names to allow, one per line)
3. Add `run.podman` (extra podman flags, envsubst is applied)
4. Add `init.sh` (container entrypoint)
5. Create `specs/<parent>/children/<name>/children/.keep`

Run with `./build <parent>/<name>` and `./contain <parent>/<name>`.

## build.args

`build.args` in a `definition/` dir can contain extra `KEY=VALUE` pairs passed as `--build-arg`. Do not add `TAG=` or `BASE=` — both are derived from the spec path.

## Instance data

Per-instance persistent home: `~/.local/share/contain/<instance>/home/user/`

Default instance name is the spec tag with `/` replaced by `--` (e.g. `ubuntu--firefox`). Override with `--name`.
