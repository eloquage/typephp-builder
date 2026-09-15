# Shared TypePHP builder for Eloquage packages (extension mode only).
# Ext mode does not need libphp.so / PHP Embed SAPI.
#
#   docker pull ghcr.io/eloquage/typephp-builder:latest
#   # or: docker build -t eloquage-typephp-builder -f packages/typephp-builder/Dockerfile packages/typephp-builder
#
# Pin TYPEPHP_REF to a commit SHA. Bump deliberately; do not float on master.

FROM php:8.5-cli-bookworm

ARG TYPEPHP_REF=30b6f43bb705b06d3dba387d10aeb140c61fce7d

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        git \
        unzip \
        ca-certificates \
        build-essential \
        cmake \
        pkg-config \
        clang-format \
        libgmp-dev \
        libmpfr-dev \
        $PHPIZE_DEPS \
    && rm -rf /var/lib/apt/lists/*

COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

WORKDIR /opt/typephp

RUN git init \
    && git remote add origin https://github.com/swoole/typephp.git \
    && git fetch --depth 1 origin "${TYPEPHP_REF}" \
    && git checkout FETCH_HEAD \
    && composer install --no-dev --prefer-dist --no-interaction --no-progress

# PHPX is required even for ext mode. Do not build PHP Embed / libphp.so.
WORKDIR /opt/typephp/vendor/swoole/phpx
RUN cmake -B build -DCMAKE_BUILD_TYPE=Release \
    && cmake --build build -j"$(nproc)" \
    && test -f lib/libphpx.so

ENV PATH="/opt/typephp/bin:/opt/typephp/vendor/bin:${PATH}" \
    COMPOSER_ALLOW_SUPERUSER=1 \
    PHPX_HOME="/opt/typephp/vendor/swoole/phpx" \
    LD_LIBRARY_PATH="/opt/typephp/vendor/swoole/phpx/lib"

WORKDIR /src

CMD ["tpc.php", "--help"]
