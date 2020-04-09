# @summary Manages the gateway node configuration.
#
# @api private
class apics::config(
  String $user,
  String $group,
  Apics::GatewayProps $gateway_props,
  Stdlib::Unixpath $gateway_props_path,
) {
  apics::gateway_props { $gateway_props_path:
    ensure => present,
    owner  => $user,
    group  => $group,
    mode   => '0440',
    props  => $gateway_props,
  }
}
