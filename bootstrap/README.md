## ZFS

For now, I just create the ZFS pools manually from within a privileged Alpine container, using `nsenter` to enter the
host init namespace from the pod:

```sh
nsenter --target 1 --mount --ipc --net --pid chroot /host \
  zpool create -f -o ashift=12 -m /var/zfs/tank tank /dev/sdb
```

The `ashift=12` above is for HDDs with 4K sectors. To verify:

```sh
nsenter --target 1 --mount --ipc --net --pid chroot /host \
  zpool list
```
