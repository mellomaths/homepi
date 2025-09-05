# Pi-Hole

Pi-Hole is a DNS server that blocks ads and trackers.

## Install

First, you need to check if dhcpcd is installed:
```bash
sudo systemctl status dhcpcd
```

In case dhcpcd is not found, you can install it with:
```bash
sudo apt update
sudo apt install --reinstall dhcpcd5
sudo reboot
```

Check the status of the dhcpcd service with:
```bash
sudo systemctl status dhcpcd
```

If the service is not running, you can start it with:
```bash
sudo systemctl start dhcpcd
```

To install pi-hole, you first need to set a static IP address to your Raspberry Pi.

```bash
sudo nano -w /etc/dhcpcd.conf
```

Add the following lines to the file:

```bash
# For wireless connection
interface wlan0
static ip_address=192.168.1.100/24
static routers=192.168.1.1
static domain_name_servers=192.168.1.1 1.1.1.1

# For wired connection
interface eth0
static ip_address=192.168.1.100/24
static routers=192.168.1.1
static domain_name_servers=192.168.1.1 1.1.1.1
```

Then restart the dhcpcd service:
```bash
sudo systemctl restart dhcpcd
```

Then install pi-hole:
```bash
just install pihole
```

## Start

```bash
just start pihole
```
```bash
just stop pihole
```
