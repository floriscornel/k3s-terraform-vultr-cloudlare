#!/bin/sh
## Change ssh port
sed -i "/Port /c\Port 2222" /etc/ssh/sshd_config
sed -i "/PubkeyAuthentication /c\PubkeyAuthentication yes" /etc/ssh/sshd_config
sed -i "/PasswordAuthentication /c\PasswordAuthentication no" /etc/ssh/sshd_config
echo "root:$(tr -dc A-Za-z0-9 </dev/urandom | head -c 13 ; echo '')" | chpasswd

# service sshd restart 
apk update
apk add curl iptables htop nano
sed -i "/default_kernel_opts=/c\default_kernel_opts=\"quiet rootfstype=ext4 cgroup_enable=cpuset cgroup_memory=1 cgroup_enable=memory\"" /etc/update-extlinux.conf
update-extlinux
reboot
