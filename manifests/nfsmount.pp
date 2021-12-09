# @summary Mount NFS export on a directory
#
# @example
#   profile_nfs_client::nfsmount { '/mnt/mount': 
#     src => 'nfs-server.local:/export/path', 
#     opts => 'defaults,nosuid,ro' 
#   }
#
define profile_nfs_client::nfsmount (
  String $src,
  Optional[String] $opts = 'defaults',
) {

  # Resource defaults
  Mount {
    ensure => mounted,
    fstype => 'nfs',
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
