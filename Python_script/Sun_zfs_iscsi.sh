#!/bin/bash
zfs create -V 256M iscsipool/ocfsqdisk1
zfs create -V 256M iscsipool/ocfsqdisk2
zfs create -V 256M iscsipool/ocfsqdisk1
zfs create -v 10G iscsipool/sourcedisk1


stmfadm create-lu /dev/Xxx/rdsk/xxxpoll/ocfsqdisk1
stmfadm create-lu /dev/Xxx/rdsk/xxxpoll/ocfsqdisk2
stmfadm create-lu /dev/Xxx/rdsk/xxxpoll/ocfsqdisk3
stmfadm create-lu /dev/Xxx/rdsk/xxxpoll/sourcedisk1





