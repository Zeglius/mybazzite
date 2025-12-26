# Packages Directory

This directory contains Earthly build definitions for various packages and components that are integrated into the main Universal Blue image. Each subdirectory typically represents a distinct package with its own `Earthfile`.

## Structure

Each subdirectory (`ananicy-cpp`, `ananicy-rules`, `incus-ui`, `nydus`, etc.) contains:
- An `Earthfile`: Defines how the package is built, tested, and what artifacts it produces.
- Source code and related assets for the package.

## Functionality

The `Earthfile`s within these subdirectories are designed to produce specific outputs (artifacts) that are then consumed by the main project's `Earthfile`.

Specifically, the `INSTALL_PACKAGES` target in the root `Earthfile` uses the following pattern:

```earthly
COPY ./packages/*+build/out/. /
```

This command:
1.  Discovers all subdirectories within `packages/`.
2.  For each subdirectory, it invokes the `build` target defined in its respective `Earthfile`.
3.  It expects the `build` target of each package's `Earthfile` to place its final artifacts into a directory named `out/` relative to that package's `Earthfile`.
4.  Finally, it copies the contents of these `out/` directories into the root of the main image build.

### Artifact Structure

Within each package's `Earthfile`, the `build` target is responsible for generating artifacts and placing them into the `out/` directory. The structure within this `out/` directory determines where the files will be copied in the final image. For example, if a package needs to install a file to `/usr/bin/mytool`, its `Earthfile` would place `mytool` at `out/usr/bin/mytool`.

### Post-Hooks

Some packages may require running scripts after their files have been copied into the image. These are known as "post-hooks".

To add a post-hook:
1.  Create a shell script (e.g., `my_post_hook.sh`) within your package's `out/.posthooks/` directory.
2.  Ensure the script is executable (`chmod +x my_post_hook.sh`).
3.  The main `Earthfile` will automatically discover and execute all scripts found in the `/run/.posthooks` directory within the build environment, after all package artifacts have been copied. These scripts are executed and then removed.

This modular approach allows for:
- **Reproducible Builds**: Each package's build process is isolated and defined in its own `Earthfile`.
- **Parallelization**: Earthly can build these packages in parallel, speeding up the overall build time.
- **Cache Efficiency**: Changes in one package only invalidate the cache for that specific package, not the entire image.

## How to add a new package

1.  Create a new subdirectory under `packages/` (e.g., `packages/my-new-package`).
2.  Inside `packages/my-new-package`, create an `Earthfile` that defines a `build` target.
3.  Ensure your `build` target outputs its desired artifacts into an `out/` directory within `packages/my-new-package`.
4.  Optionally, if post-hook scripts are needed, place them in `packages/my-new-package/out/.posthooks/` and make them executable.
5.  The main `Earthfile` will automatically discover and integrate your package's artifacts and post-hooks during the `INSTALL_PACKAGES` step.