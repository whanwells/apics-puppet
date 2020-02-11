# @summary Manages the gateway user, group, and installation files.
#
# @api private
class apics::install(
  String $user,
  String $group,
  Boolean $manage_user,
  Boolean $manage_group,
  Stdlib::Unixpath $basedir,
  Stdlib::Unixpath $installer_extract_path,
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
}
