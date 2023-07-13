# @summary Configure NFS client and mounts
#
# @param masked_units
#   List of systemctl units that should to be masked
#
# @param mountmap
#   mapping of NFS exports to local mount points
#
#   Example hiera parameter:
# ```
#   profile_nfs_client::mountmap:
#     /mnt/mount:
#       src: "nfs-server.local:/export/path"
#       fstype: "nfs4"
#       opts: "defaults,nosuid,nodev,ro"
# ```
#
# @param required_pkgs
#   Packages that need to be installed for NFS mounts to work.
# 
# @example
#   include profile_nfs_client
class profile_nfs_client (
  Array[String] $masked_units,
  Hash            $mountmap,
  Array[String] $required_pkgs,
) {
  ensure_packages( $required_pkgs )

  each($masked_units) | $unit | {
    exec { "mask_unit_${unit}":
      command => "systemctl mask --now ${unit}",
      unless  => "systemctl is-enabled ${unit} | grep -i masked",
      path    => ['/bin', '/usr/bin', '/usr/sbin'],
    }
  }

  $mountmap.each | $k, $v | {
    profile_nfs_client::nfsmount { $k: * => $v }
  }
}
