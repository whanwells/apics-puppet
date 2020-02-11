# @summary Manages an Oracle API Platform gateway node.
#
# When declared with the default attributes, Puppet will:
#
# - Create the gateway node user and group.
#
# @example
#   include apics
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
class apics(
  String $user,
  String $group,
  Boolean $manage_user,
  Boolean $manage_group,
  Stdlib::Unixpath $basedir,
) {
  $installer_extract_path = "${basedir}/installer"

  class { 'apics::install':
    user                   => $user,
    group                  => $group,
    manage_user            => $manage_user,
    manage_group           => $manage_group,
    basedir                => $basedir,
    installer_extract_path => $installer_extract_path,
  }

  contain apics::install
}
