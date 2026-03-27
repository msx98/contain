# contain

Run desktop applications in isolated Podman containers with full Wayland, audio, and GPU support.

## Overview

`contain` sandboxes GUI applications using Podman while maintaining native integration with your desktop:

- **Display**: Wayland socket proxy (read-only)
- **Audio**: PipeWire / PulseAudio socket proxy
- **GPU**: Direct rendering (`/dev/dri`)
- **D-Bus**: Filtered via `xdg-dbus-proxy`
- **Filesystem**: Per-app persistent home at `~/.local/share/contain/<instance>/`

## Requirements

- Podman
- `xdg-dbus-proxy`
- Wayland compositor
- PipeWire (recommended) or PulseAudio

## Usage

```bash
./contain <spec-tag>  # Run the container

# Examples
./contain ubuntu/firefox
./contain --build ubuntu/vscode
./contain hard-fedora/chrome
```

Spec tags follow the parent hierarchy using `/` as separator. The corresponding image tag uses `--` (e.g. `localhost/contain:ubuntu--firefox`). Parent images are auto-built if missing.

Options for `./contain`:
```
--rebuild   Force rebuild of the image
--shell     Drop into a bash shell instead of launching the app
--update    Re-run setup scripts
--name <n>  Override the instance name (for running multiple instances)
```

## Spec structure

Specs live under `specs/` in a parent/child hierarchy. Each spec has a `definition/` directory containing its files, and a `children/` directory for derived specs.

```
specs/
  <name>/
    definition/      # spec files for this image
      Containerfile
      build.args     # optional extra --build-arg values
      init.sh        # entrypoint run inside the container
      run.dbus       # D-Bus service names to allow (one per line)
      run.podman     # extra podman run flags (one per line, envsubst applied)
      desktop        # .desktop template (optional, auto-installed on launch)
      setup.sh       # post-build root setup (optional)
      setup.user.sh  # post-build user setup (optional)
      init.root.sh   # per-run root init (optional)
    children/
      .keep
      <child>/       # child spec (uses parent image as BASE)
        definition/
          ...
        children/
          .keep
```

### Adding a spec

To add a top-level base image:
```
specs/mybase/definition/Containerfile
specs/mybase/definition/init.sh
specs/mybase/children/.keep
```

To add an app that builds on `ubuntu`:
```
specs/ubuntu/children/myapp/definition/Containerfile
specs/ubuntu/children/myapp/definition/run.dbus
specs/ubuntu/children/myapp/definition/run.podman
specs/ubuntu/children/myapp/children/.keep
```

Then:
```bash
./build ubuntu/myapp
./contain ubuntu/myapp
```

The `BASE` build arg is automatically set to the parent's image tag. The `Containerfile` should use `ARG BASE` / `FROM $BASE` to inherit from it.

## Security model

- `--no-new-privileges`
- User namespace: `--userns keep-id`
- Network: `pasta` (isolated namespace)
- D-Bus: only services listed in `run.dbus` are proxied
- Wayland socket: read-only
- All capabilities dropped for the main process

## Directory structure

```
contain/
├── specs/           # Container specs (nested parent/child hierarchy)
├── bin/             # CNI plugins
├── build            # Build script
├── contain          # Run script
└── proxy-socket     # Helper: proxy a Unix socket for cross-UID access
```
