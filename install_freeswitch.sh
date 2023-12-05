#!/bin/bash

if [ $# -eq 0 ]; then
    echo "Usage: $0 <SignalWireToken>"
    exit 1
fi

TOKEN="$1"

apt-get update && apt-get install -y gnupg2 wget lsb-release

wget --http-user=signalwire --http-password="$TOKEN" -O /usr/share/keyrings/signalwire-freeswitch-repo.gpg https://freeswitch.signalwire.com/repo/deb/debian-release/signalwire-freeswitch-repo.gpg

echo "machine freeswitch.signalwire.com login signalwire password $TOKEN" > /etc/apt/auth.conf
chmod 600 /etc/apt/auth.conf
echo "deb [signed-by=/usr/share/keyrings/signalwire-freeswitch-repo.gpg] https://freeswitch.signalwire.com/repo/deb/debian-release/ $(lsb_release -sc) main" > /etc/apt/sources.list.d/freeswitch.list
echo "deb-src [signed-by=/usr/share/keyrings/signalwire-freeswitch-repo.gpg] https://freeswitch.signalwire.com/repo/deb/debian-release/ $(lsb_release -sc) main" >> /etc/apt/sources.list.d/freeswitch.list

# you may want to populate /etc/freeswitch at this point.
# if /etc/freeswitch does not exist, the standard vanilla configuration is deployed
apt-get update && apt-get install -y freeswitch-meta-all

# Get installed Freeswitch version
INSTALLED_VERSION=$(dpkg -l | grep freeswitch-meta-all | awk '{print $3}')

echo "Freeswitch was installed successfully."
echo "Installed version: $INSTALLED_VERSION"
