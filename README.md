# TypePHP builder (`eloquage/typephp-builder`)

Shared Docker image and reusable GitHub Actions for compiling Eloquage path packages as TypePHP **extensions** (`mode: ext`). This package is not a Composer runtime dependency and has no public PHP API.

## Image

Published as `ghcr.io/eloquage/typephp-builder` (tags: short `TYPEPHP_REF` SHA + `latest`).

```bash
docker pull ghcr.io/eloquage/typephp-builder:latest
# or: docker build -t eloquage-typephp-builder -f packages/typephp-builder/Dockerfile packages/typephp-builder
```

The image includes PHP 8.5 CLI, `tpc`, and `libphpx.so`. It does not build PHP Embed / `libphp.so`. Do not Composer-require `swoole/typephp` in path packages.

This repo does **not** compile itself with `tpc` (no `project.yml.example`).

## Reusable native CI

Path packages call `.github/workflows/native-ci.yml` on `v*` tags (pin `@v1`). That job compiles `mode: ext`, loads `eloquage_<package>.so` into the same PHP, and runs Pest. Compile, load, or test failure fails the job.

## Local compile (harness)

```bash
docker/typephp/build-package.sh vector
```
