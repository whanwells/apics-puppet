# @summary Manages the gateway user, group, and installation files.
#
# @api private
class apics::install(
  String $user,
  String $group,
  Boolean $manage_user,
  Boolean $manage_group,
  Stdlib::Unixpath $basedir,
  Stdlib::Filesource $installer_source,
  Stdlib::Filesource $installer_target,
  Stdlib::Unixpath $installer_extract_path,
  Boolean $installer_cleanup,
) {
  if $manage_user {
    user { $user:
      ensure => present,
      gid    => $group,
    }
  }

  if $manage_group {
    group { $group:
      ensure => present,
    }
  }

  [$basedir, $installer_extract_path].each |$dir| {
    file { $dir:
      ensure => directory,
      owner  => $user,
      group  => $group,
      mode   => '0755',
    }
  }

  $archive_creates = "${installer_extract_path}/APIGateway"

  archive { $installer_target:
    source       => $installer_source,
    extract      => true,
    extract_path => $installer_extract_path,
    user         => $user,
    creates      => $archive_creates,
    cleanup      => $installer_cleanup,
  }
}
