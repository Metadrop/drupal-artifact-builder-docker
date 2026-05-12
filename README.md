# drupal-artifact-builder Docker image

Alpine-based Docker image that provides all the tools needed to run [drupal-artifact-builder](https://github.com/metadrop/drupal-artifact-builder) in CI pipelines or automated environments.

Includes:

- PHP (CLI) with a broad set of extensions: gd, intl, zip, pdo_mysql, pdo_pgsql, redis, apcu, imagick, bcmath, soap, ldap, and more
- Composer 2
- Node.js + npm/npx (for frontend asset compilation steps)
- Git with a default system identity (`artifact-builder@localhost`)

## Published images

Images are published to the [GitHub Container Registry](https://github.com/metadrop/drupal-artifact-builder-docker/pkgs/container/drupal-artifact-builder-docker).

<!-- IMAGES-TABLE-START -->
<!-- IMAGES-TABLE-END -->

## Build

```bash
docker build -t drupal-artifact-builder-docker .
```

### PHP and Node versions

Both are controlled via build arguments:

| Argument | Default |
|---|---|
| `PHP_VERSION` | `8.3` |
| `NODE_VERSION` | `20` |

```bash
docker build \
  --build-arg PHP_VERSION=8.2 \
  --build-arg NODE_VERSION=18 \
  -t drupal-artifact-builder-docker:php82-node18 .
```

## Usage

Mount your Drupal project root at `/app` and run the builder:

```bash
docker run --rm \
  -v "$(pwd)":/app \
  -v ~/.ssh:/root/.ssh:ro \
  drupal-artifact-builder-docker \
  drupal-artifact-builder build
```

A `.drupal-artifact-builder.yml` file must exist in the project root. Copy it from the dist template:

```bash
cp vendor/metadrop/drupal-artifact-builder/.drupal-artifact-builder.yml.dist .drupal-artifact-builder.yml
```

## Extending the image

Use this image as a base and layer in whatever your project needs:

```dockerfile
FROM drupal-artifact-builder-docker:latest

RUN apk add --no-cache yarn
```
