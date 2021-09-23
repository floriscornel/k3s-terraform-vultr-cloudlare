#!/bin/sh
sed -i "/v3.14\/community/c\http:\/\/dl-cdn.alpinelinux.org\/alpine\/v3.14\/community" /etc/apk/repositories
apk update
apk add cloud-utils-growpart e2fsprogs-extra
growpart /dev/vda 3
resize2fs /dev/vda3