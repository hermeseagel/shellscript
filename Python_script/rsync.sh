#!/usr/bin/sh

rpm -ivh libiconv-1.14-2.aix5.1.ppc.rpm
rpm -ivh popt-1.16-1.aix5.1.ppc.rpm

/opt/freeware/man/man5/rsyncd.conf.5

[webb1]
path = /backup/
auth users = bk_user
uid = root
gid = root
secrets file = /etc/rsyncd.secrets
read only = no

