#!/bin/bash
set -e

# Update and install system packages
apt update
apt install -y proxychains4
sed -i 's/^socks4[[:space:]]\+127\.0\.0\.1[[:space:]]\+9050/socks5 172.17.0.1 1081/' /etc/proxychains4.conf

# Optional: install extra system packages if packages.txt exists
if [ -f /tmp/packages.txt ]; then
    xargs -a /tmp/packages.txt apt install -y
fi
pipx ensurepath


# Modify proxychains config

# Install theme wheels
pip install /themes/*.whl

# Install Python requirements
pip install -r /tmp/requirements.txt

