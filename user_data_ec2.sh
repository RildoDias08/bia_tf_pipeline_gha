#!/bin/bash
set -euxo pipefail
exec > >(tee /var/log/user-data.log | logger -t user-data -s 2>/dev/console) 2>&1

yum update -y
yum install -y git docker jq curl

systemctl enable docker
systemctl start docker
usermod -aG docker ec2-user || true
usermod -aG docker ssm-user || true

# Esperar docker ficar pronto
until docker info >/dev/null 2>&1; do
  echo "Aguardando docker..."
  sleep 2
done

mkdir -p /usr/local/lib/docker/cli-plugins
curl -fSL https://github.com/docker/compose/releases/download/v2.23.3/docker-compose-linux-x86_64 \
  -o /usr/local/lib/docker/cli-plugins/docker-compose
chmod +x /usr/local/lib/docker/cli-plugins/docker-compose

# Swap (evita OOM no build)
if [ ! -f /swapfile ]; then
  dd if=/dev/zero of=/swapfile bs=128M count=32
  chmod 600 /swapfile
  mkswap /swapfile
fi

swapon /swapfile || true
grep -q swapfile /etc/fstab || echo "/swapfile swap swap defaults 0 0" >> /etc/fstab