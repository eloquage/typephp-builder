# eloquage/typephp-builder

Shared TypePHP **ext** builder image (`ghcr.io/eloquage/typephp-builder`) and reusable native CI. Not a consumer PHP library. Do not add this package to Laravel `require`. Do not add a welcome `data-package` panel.

## Layout

- `Dockerfile` — PHP 8.5 CLI + TypePHP (`tpc`) + PHPX (`libphpx.so`)
- `.github/workflows/publish-typephp-builder.yml` — GHCR publish
- `.github/workflows/native-ci.yml` — `workflow_call`: compile, load `.so`, Pest

No `src/`, no `project.yml.example`, no `tpc` of this package.

## Commands

```bash
docker build -t eloquage-typephp-builder -f packages/typephp-builder/Dockerfile packages/typephp-builder
docker run --rm eloquage-typephp-builder tpc.php --help
```

Pin path-package callers to `eloquage/typephp-builder/.github/workflows/native-ci.yml@v1`.
