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

Plain HTTP registries must be listed as **insecure** on every machine that pushes or pulls (including the Pi).

**Linux** (`/etc/docker/daemon.json`):

```json
{
  "insecure-registries": ["192.168.1.100:5000"]
}
```

Adjust the host to your Pi IP or LAN DNS name. Merge with existing keys if the file already exists. Restart Docker: `sudo systemctl restart docker`.

**Docker Desktop (Windows/macOS):** Settings → Docker Engine → add `insecure-registries` as above → Apply & Restart.

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
