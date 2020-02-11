# @summary Manages the gateway user and group.
#
# @api private
class apics::install(
  String $user,
  String $group,
  Boolean $manage_user,
  Boolean $manage_group,
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
}
