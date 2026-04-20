# Docker Registry (local)

Private [Docker Registry v2](https://docs.docker.com/registry/) on the Pi. Images are stored in the `registry_data` Docker volume (`/var/lib/registry` inside the container).

## Start and stop

From the repo root:

```bash
just start registry
just stop registry
```

Or from this directory: `./start.sh` / `./stop.sh`.

Default URL: `http://<pi-ip>:5000` (container listens on host port **5000**).

## Configure Docker clients (required)

The registry serves **plain HTTP**. Docker assumes **HTTPS** for any registry hostname unless you whitelist it. You must configure **every host** that runs `docker pull` or `docker push` against this registry—including **the Raspberry Pi itself** when you pull images there.

**Linux** (Pi, servers, Docker Engine) depends on how Docker runs:

- **Root Docker (default on many servers):** `docker version` has no `Context: rootless`. Use **`/etc/docker/daemon.json`**, then `sudo systemctl restart docker`.
- **Rootless Docker** (common on a user install; `docker version` shows **`Context: rootless`**): the daemon does **not** read `/etc/docker/daemon.json`. Use **`~/.config/docker/daemon.json`** for the same user that runs `docker` (e.g. `homepi`), then restart the **user** service: `systemctl --user restart docker`. If you edit the wrong file, `insecure-registries` will never appear in `docker info`.

If the file does not exist, create it. If it already has keys (logging, proxies, etc.), merge `insecure-registries` into the **same JSON object**—do not duplicate top-level `{}`.

Example for a Pi at `192.168.1.100`:

```json
{
  "insecure-registries": ["192.168.1.100:5000"]
}
```

Then reload Docker (**pick one**):

```bash
# Root Docker
sudo systemctl restart docker

# Rootless Docker (same user as docker run / pull)
systemctl --user restart docker
```

Confirm Docker picked it up (look for `Insecure Registries`):

```bash
docker info | grep -i insecure -A 10
```

You should see `192.168.1.100:5000` listed.

**Docker Desktop (Windows/macOS):** Settings → Docker Engine → add `insecure-registries` as above → Apply & Restart.

### Troubleshooting

**Error:** `http: server gave HTTP response to HTTPS client` when pulling or pushing.

**Cause:** Docker tried HTTPS against an HTTP-only registry.

**Fix:** Add this registry URL (host **and** port as you use them in image names) to `insecure-registries` on **that machine**, restart Docker, retry the pull.

**Still missing from `docker info`?** Run `docker version`—if you see **`Context: rootless`**, you must edit **`~/.config/docker/daemon.json`** and run **`systemctl --user restart docker`**, not `/etc/docker/daemon.json` + `sudo systemctl restart docker`.

### HTTPS via Nginx (optional)

To avoid `insecure-registries`, terminate TLS in [`apps/nginx`](../nginx/) and proxy to `http://127.0.0.1:5000`. Clients then use `registry.homepi.net` (or similar) over HTTPS with a trusted certificate.

## Push images from your dev machine

After building locally:

```bash
docker tag myapp:latest 192.168.1.100:5000/myapp:latest
docker push 192.168.1.100:5000/myapp:latest
```

## Use images in Compose on the Pi

Set the service `image` to your registry reference, for example:

```yaml
image: 192.168.1.100:5000/myapp:latest
```

Deploy with pull:

```bash
docker compose pull && docker compose up -d
```

## API Gateway deploy script (`registry` mode)

After each app’s `docker-compose.yml` uses images from this registry (see [`apps/api-gateway/deploy.sh`](../api-gateway/deploy.sh)), deploy with:

```bash
DEPLOY_MODE=registry ./deploy.sh
```

This updates existing clones with `git pull` (or clones once), then runs `docker compose pull && docker compose up -d` instead of rebuilding on the Pi.

## Notes

- `REGISTRY_STORAGE_DELETE_ENABLED` is on in Compose so you can delete tags via the registry API if needed; restrict network access or add registry auth if you expose the service beyond a trusted LAN.
- Use Portainer or `docker images` on the Pi to inspect pulled images; the official `registry` image does not ship a web UI.
