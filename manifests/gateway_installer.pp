# @summary Manages a gateway node installer.
#
# @example
#   apics::gateway_installer { '/opt/installer':
#     ensure => present,
#     owner  => 'oracle',
#     group  => 'oracle',
#     source => '/tmp/ApicsGatewayInstaller.zip',
#   }
#
# @param ensure
#   Whether or not the installer should exist.
#
# @param path
#   The path of the installer directory.
#
# @param owner
#   The user that owns the installer directory.
#
# @param group
#   The group that owns the installer directory.
#
# @param mode
#   The permissions of the installer directory.
#
# @param source
#   The location of the gateway node installer archive.
#
# @param target
#   The location where the gateway node installer archive will be copied.
#
# @param force
#   Whether or not an existing installer can be overwritten.
#
# @param cleanup
#   Whether or not the installer archive will be removed after extraction.
define apics::gateway_installer (
  Enum['present', 'absent'] $ensure,
  String $owner,
  String $group,
  Stdlib::Filesource $source,
  Stdlib::Unixpath $path = $title,
  Stdlib::Filemode $mode = '0700',
  Stdlib::Unixpath $target = '/tmp/ApicsGatewayInstaller.zip',
  Boolean $force = false,
  Boolean $cleanup = false,
) {
  if $ensure == 'present' {
    file { $path:
      ensure => directory,
      owner  => $owner,
      group  => $group,
      mode   => $mode,
    }

    $creates  = $force ? {
      true    => undef,
      default => "${path}/APIGateway",
    }

    archive { $target:
      source       => $source,
      extract      => true,
      extract_path => $path,
      user         => $owner,
      group        => $group,
      creates      => $creates,
      cleanup      => $cleanup,
    }
  }
  else {
    file { $path:
      ensure  => absent,
      recurse => true,
      purge   => true,
      force   => true,
    }
  }
}
