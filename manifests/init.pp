# @summary Manages an Oracle API Platform gateway node.
#
# When declared with the minimum attributes, Puppet will:
#
# - Create the gateway node user and group.
# - Download and extract the gateway node installer.
#
# @example
#   class { 'apics':
#     installer_source => '/path/to/ApicsGatewayInstaller.zip',
#   }
#
# @param user
#   The name of the gateway node user. Default: 'oracle'.
#
# @param group
#   The name of the gateway node group. Default: 'oracle'.
#
# @param manage_user
#   Whether or not the gateway node user will be managed. Default: `true`.
#
# @param manage_group
#   Whether or not the gateway node user will be managed. Default: `true`.
#
# @param basedir
#   The root directory of the gateway node directory tree. Default: '/opt/oracle'.
#
# @param installer_source
#   The location of the gateway node installer.
#
# @param installer_target
#   The location where the gateway node installer will be copied. Default: '/tmp/ApicsGatewayInstaller.zip'.
#
# @param installer_cleanup
#   Whether or not the installer file will be removed after extraction. Default: `false`.
class apics(
  String $user,
  String $group,
  Boolean $manage_user,
  Boolean $manage_group,
  Stdlib::Unixpath $basedir,
  Stdlib::Filesource $installer_source,
  Stdlib::Unixpath $installer_target,
  Boolean $installer_cleanup,
) {
  $installer_extract_path = "${basedir}/installer"

  class { 'apics::install':
    user                   => $user,
    group                  => $group,
    manage_user            => $manage_user,
    manage_group           => $manage_group,
    basedir                => $basedir,
    installer_source       => $installer_source,
    installer_target       => $installer_target,
    installer_extract_path => $installer_extract_path,
    installer_cleanup      => $installer_cleanup,
  }

  contain apics::install
}
