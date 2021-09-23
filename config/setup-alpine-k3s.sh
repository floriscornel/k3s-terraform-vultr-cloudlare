#!/bin/sh
USER=user
PUB_KEY="ssh-ed25519 xxx"

## Setup SSH key
rm ~/.ssh/*
echo "${PUB_KEY}" > ~/.ssh/authorized_keys

## Grow disk to max size
sed -i "/v3.14\/community/c\http:\/\/dl-cdn.alpinelinux.org\/alpine\/v3.14\/community" /etc/apk/repositories
apk update
apk add cloud-utils-growpart e2fsprogs-extra
growpart /dev/vda 2
resize2fs /dev/vda2

## Change ssh port
sed -i "/Port /c\Port 2222" /etc/ssh/sshd_config
sed -i "/PubkeyAuthentication /c\PubkeyAuthentication yes" /etc/ssh/sshd_config
sed -i "/PasswordAuthentication /c\PasswordAuthentication no" /etc/ssh/sshd_config
echo "root:$(tr -dc A-Za-z0-9 </dev/urandom | head -c 13 ; echo '')" | chpasswd

# service sshd restart 
apk add curl iptables
sed -i "/default_kernel_opts=/c\default_kernel_opts=\"quiet rootfstype=ext4 cgroup_enable=cpuset cgroup_memory=1 cgroup_enable=memory\"" /etc/update-extlinux.conf
update-extlinux
reboot
