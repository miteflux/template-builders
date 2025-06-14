#!/bin/sh

set -euxo pipefail

sed -ie "\$ahttp://dl-cdn.alpinelinux.org/alpine/v3.22/main" /etc/apk/repositories
sed -ie "\$ahttp://dl-cdn.alpinelinux.org/alpine/v3.22/community" /etc/apk/repositories
apk update
apk upgrade --available
apk add --no-cache py3-netifaces py3-pyserial cloud-init cloud-utils qemu-guest-agent xfsprogs ntfs-3g ntfs-3g-progs btrfs-progs testdisk mc 7zip e2fsprogs e2fsprogs-extra libblockdev lsblk parted sfdisk sgdisk eudev mount curl

setup-cloud-init

cloud-init status -l
cloud-init clean --logs
#cloud-init query userdata

rm -rf /etc/motd

cat > /etc/motd <<EOF
This environment is intended for system recovery, troubleshooting, and diagnostics.

Common Tasks:
   - Mount your root filesystem:   mount /dev/sdXn /mnt
   - Chroot into your system:      chroot /mnt
   - Check disk health:            smartctl -a /dev/sdX`
   - Network troubleshooting:      ip a, ping, curl

⚠  WARNING:
   This is a temporary environment. No changes made here will persist
   unless written to the mounted filesystem.

📦  Tools Available:
   - Filesystem repair: fsck, e2fsck
   - Partitioning:      fdisk, parted
   - Networking:        ip, ifconfig, ping, wget, curl
   - Editors:           nano, vi

EOF

sed -i 's/#GA_PATH=.*$/GA_PATH="\/dev\/vport2p1"/' /etc/conf.d/qemu-guest-agent

rc-update add qemu-guest-agent
rc-service qemu-guest-agent restart

sed -i 's/dhcp/manual/g' /etc/network/interfaces
rm -rf /var/cache/apk/*
rm -rf /tmp/*
rm -rf /var/tmp/*
rm -rf /etc/ssh/*_key /etc/ssh/*_key.pub

if [[ -d /root/.ssh ]]; then
		rm -f /root/.ssh/authorized_keys
		echo -n > /root/.ssh/known_hosts
		chmod 0644 /root/.ssh/known_hosts
fi

passwd -d root
passwd -l root

find /var/log -type f | while read f; do echo -ne '' > ${f}; done;
echo -n > /root/.bash_history
echo -n > /root/.ash_history
echo -n > /etc/resolv.conf

dd if=/dev/zero of=/zeroed_file bs=1M oflag=direct || /bin/true
rm -rf /zeroed_file

sync