# @summary Configure NFS client and mounts
#
# @param required_pkgs
#   Packages that need to be installed for NFS mounts to work.
# 
# @param mountmap
#   mapping of NFS exports to local mount points
#
#   Example hiera parameter:
# ```
#   profile_nfs_client::mountmap:
#     /mnt/mount:
#       src: "nfs-server.local:/export/path"
#       opts: "defaults,nosuid,ro"
# ```
#
# @example
#   include profile_nfs_client
class profile_nfs_client (
  Array[ String ] $required_pkgs,
  Hash $mountmap,
) {

  ensure_packages( $required_pkgs )

  $mountmap.each | $k, $v | {
    profile_nfs_client::nfsmount { $k: * => $v }
  }

}
