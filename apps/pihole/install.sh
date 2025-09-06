curl -sSL https://install.pi-hole.net | bash
sudo apt install --reinstall dhcpcd5 -y
sudo systemctl start dhcpcd
sudo systemctl enable dhcpcd

sudo apt install unbound -y
