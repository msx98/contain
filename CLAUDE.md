# contain — developer notes

## Spec system

Specs live under `specs/` in a freely-organized flat directory structure. Each spec is a directory containing its files directly (no `definition/` or `children/` subdirs).

A spec tag is the path from `specs/` with `/` replaced by `--`:

- `specs/base/ubuntu/` → tag `base--ubuntu` → image `localhost/contain:base--ubuntu`
- `specs/browsers/firefox/` → tag `browsers--firefox` → image `localhost/contain:browsers--firefox`
- `specs/utilities/scrcpy/` → tag `utilities--scrcpy` → image `localhost/contain:utilities--scrcpy`

The directory layout is for human organization only. Build hierarchy is declared via `build.parent`.

## build.parent

`build.parent` contains the parent spec tag (e.g. `base--ubuntu`). At build time the script passes `--build-arg BASE=localhost/contain:<parent>` so Containerfiles use `ARG BASE` / `FROM $BASE` as usual.

Specs without a Containerfile (runtime-config-only) also use `build.parent` — building them is a no-op that just ensures the parent image exists.

## Scripts

**`contain build <spec-tag>`** — finds `specs/<tag with -- replaced by />`, reads `build.parent` to auto-build the parent if missing, then runs `podman build`.

**`contain run <spec-tag>`** — resolves the image (walking up `build.parent` chain to find the nearest Containerfile), starts socket proxies (Wayland, PipeWire, PulseAudio, D-Bus), mounts the persistent home at `~/.local/share/contain/<instance>/`, and runs the container.

## Adding a new spec

1. Create `specs/<category>/<name>/Containerfile` — use `ARG BASE` / `FROM $BASE`
2. Add `build.parent` containing the parent spec tag
3. Add `run.dbus` (D-Bus names to allow, one per line)
4. Add `run.podman` (extra podman flags, envsubst is applied)
5. Add `init.sh` (container entrypoint)

For a runtime-config-only spec (no build step): omit `Containerfile`, add only `build.parent` and runtime files.

Run with `./contain build <category>--<name>` and `./contain run <category>--<name>`.

## build.args

`build.args` in a spec dir can contain extra `KEY=VALUE` pairs passed as `--build-arg`. `BASE` is handled automatically via `build.parent` — do not add it here.

## Instance data

Per-instance persistent home: `~/.local/share/contain/<instance>/home/user/`

Default instance name is the spec tag (e.g. `browsers--firefox`). Override with `--name`.
