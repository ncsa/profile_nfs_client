# @summary Mount NFS export on a directory
#
# @param src
#   Source filesystem to be mounted
#
# @param fstype
#   Filesystem type to be mounted
#
# @param opts
#   Options for the filesystem mount
#
# @example
#   profile_nfs_client::nfsmount { '/mnt/mount': 
#     src => 'nfs-server.local:/export/path', 
#     fstype => 'nfs',
#     opts => 'defaults,nosuid,nodev,ro' 
#   }
#
define profile_nfs_client::nfsmount (
  String $src,
  Optional[String] $fstype = 'nfs',
  Optional[String] $opts = 'defaults,nosuid,nodev',
) {

  # Resource defaults
  Mount {
    ensure => mounted,
    fstype => $fstype,
  }
  File {
    ensure => directory,
  }

  # Ensure parents of target dir exist, if needed (excluding / )
  $dirparts = reject( split( $name, '/' ), '^$' )
  $numparts = size( $dirparts )
  if ( $numparts > 1 ) {
    each( Integer[2,$numparts] ) |$i| {
      ensure_resource(
        'file',
        reduce( Integer[2,$i], $name ) |$memo, $val| { dirname( $memo ) },
        { 'ensure' => 'directory' }
      )
    }
  }

  # Ensure target directory exists
  file { $name: }

  # Define the mount point
  mount { $name:
    device  => $src,
    options => $opts,
    require => [
      File[ $name ],
      Package[ $profile_nfs_client::required_pkgs ],
    ],
  }

}
