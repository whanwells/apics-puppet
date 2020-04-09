# @summary Manages a gateway properties file.
#
# @example
#   apics::gateway_props { '/tmp/gateway-props.json':
#     ensure => present,
#     owner  => 'oracle',
#     group  => 'oracle',
#     mode   => '0444',
#     props  => {
#       'nodeInstallDir'  => '/opt/oracle/gateway',
#       'listenIpAddress' => $facts['ipaddress'],
#       'publishAddress'  => $facts['fqdn'],
#     },
#   }
#
# @param ensure
#   Whether the file should exist. Valid options: 'present', 'absent'.
#
# @param owner
#   The owner of the file.
#
# @param group
#   The group which owns the file.
#
# @param mode
#   The permissions of the file.
#
# @param path
#   The path to the file.
#
# @param props
#   The properties to write to the file. All values will be converted to strings and undef values will be dropped.
define apics::gateway_props (
  Enum['present', 'absent'] $ensure,
  String $owner,
  String $group,
  Stdlib::Filemode $mode,
  Stdlib::Unixpath $path = $title,
  Apics::GatewayProps $props = {}
) {
  $entries = $props.filter |$k, $v| { $v =~ NotUndef }.map |$k, $v| { [$k, String($v)] }

  file { $path:
    ensure  => $ensure,
    owner   => $owner,
    group   => $group,
    mode    => $mode,
    content => to_json_pretty(Hash($entries)),
  }
}
