# Cockpit

## Changing default port

Edit the file `/etc/systemd/system/cockpit.socket.d/listen.conf` and change the port to 8004.
If folder does not exist, create it with the following command.
```bash
sudo mkdir -p /etc/systemd/system/cockpit.socket.d
```

Add the following content to the file with the following command.
```bash
sudo nano /etc/systemd/system/cockpit.socket.d/listen.conf
```

```ini
[Socket]
ListenStream=
ListenStream=8004
FreeBind=yes
```

Restart the service.
```bash
sudo systemctl daemon-reload
sudo systemctl restart cockpit.socket
```
