# TypePHP Builder

![TypePHP Builder](art/banner.png)

Shared Docker image and reusable GitHub Actions for compiling Eloquage path packages as TypePHP extensions (`mode: ext`). This repository is build infrastructure, not a Composer runtime dependency.

The image contains PHP 8.5 CLI, `tpc`, and `libphpx.so`. It does not build PHP Embed or `libphp.so`.

## Run the builder

Pull the published image and check the compiler:

```bash
docker pull ghcr.io/eloquage/typephp-builder:latest
docker run --rm ghcr.io/eloquage/typephp-builder:latest tpc.php --help
```

Build the image from this repository instead:

```bash
docker build -t eloquage-typephp-builder .
docker run --rm eloquage-typephp-builder tpc.php --help
```

The publish workflow tags the image with the pinned TypePHP source commit and `latest`. Set `TYPEPHP_REF` in `.github/workflows/publish-typephp-builder.yml` to update that source revision.

## Use native CI in a path package

Call the reusable workflow from your package repository. It compiles the extension, loads it into PHP, then runs Pest:

```yaml
name: Native CI

on:
  push:
    tags: ['v*']

jobs:
  native:
    uses: eloquage/typephp-builder/.github/workflows/native-ci.yml@v1
```

The caller needs a `project.yml.example` describing an extension build and a Pest suite. The workflow compiles the extension, loads it into PHP, and runs Pest when the caller pushes a `v*` release tag.

## Scope

This repository does not compile itself with `tpc`; it has no `project.yml.example` or public PHP API. Do not add `swoole/typephp` to consuming packages' Composer requirements.
