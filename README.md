# profile_nfs_client

![pdk-validate](https://github.com/ncsa/puppet-profile_nfs_client/workflows/pdk-validate/badge.svg)
![yamllint](https://github.com/ncsa/puppet-profile_nfs_client/workflows/yamllint/badge.svg)

NCSA Common Puppet Profiles - configure NFS client and mounts

## Usage

To install and configure:

```puppet
include profile_nfs_client
```

## Configuration

The following parameters need to be set (hiera example):
```
profile_nfs_client::mountmap:
  /mnt/mount:
    src: "nfs-server.local:/export/path"
    opts: "defaults,nosuid,ro"
```

## Reference

[REFERENCE.md](REFERENCE.md)
