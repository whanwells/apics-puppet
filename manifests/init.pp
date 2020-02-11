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
class apics(
  String $user,
  String $group,
  Boolean $manage_user,
  Boolean $manage_group,
) {
  class { 'apics::install':
    user         => $user,
    group        => $group,
    manage_user  => $manage_user,
    manage_group => $manage_group,
  }

  contain apics::install
}
