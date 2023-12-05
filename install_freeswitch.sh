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

# Check if links should be created
if [ "$CREATE_LINKS" = true ]; then
    # Create symbolic links in /usr/local/freeswitch/bin
    mkdir -p /usr/local/freeswitch/bin
    ln -s /usr/bin/freeswitch /usr/local/freeswitch/bin/
    ln -s /usr/bin/fs_* /usr/local/freeswitch/bin/
    ln -s /usr/bin/fsxs /usr/local/freeswitch/bin/
    ln -s /usr/bin/tone2wav /usr/local/freeswitch/bin/
    ln -s /usr/bin/gentls_cert /usr/local/freeswitch/bin/
    ln -s /etc/freeswitch /usr/local/freeswitch/conf
    ln -s /var/lib/freeswitch/* /usr/local/freeswitch/
    ln -s /var/log/freeswitch /usr/local/freeswitch/log
    ln -s /var/run/freeswitch /usr/local/freeswitch/run
    ln -s /etc/freeswitch/tls /usr/local/freeswitch/certs
    ln -s /usr/lib/freeswitch/mod /usr/local/freeswitch/
    rm /usr/local/freeswitch/lang

    echo "Se crearon los enlaces simbólicos en /usr/local/freeswitch/"
else
    echo "No se crearon enlaces simbólicos. Para crearlos, proporciona el parámetro 'join' después del token."
fi


echo "Freeswitch was installed successfully."
echo "Installed version: $INSTALLED_VERSION"
