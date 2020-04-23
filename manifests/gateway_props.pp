# @summary Manages a gateway properties file.
#
# @example
#   apics::gateway_props { '/tmp/gateway-props.json':
#     ensure => present,
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
# @param path
#   The path to the file.
#
# @param props
#   The properties to write to the file. All values will be converted to strings and undefs will be dropped.
define apics::gateway_props (
  Enum['present', 'absent'] $ensure,
  Stdlib::Unixpath $path = $title,
  Apics::GatewayProps $props = {}
) {
  if !defined(Class['apics']) {
    fail('You must include the base apics class before using any of its defined resources')
  }

  $entries = $props.filter |$k, $v| { $v =~ NotUndef }.map |$k, $v| { [$k, String($v)] }

  file { $path:
    ensure    => $ensure,
    owner     => $apics::user,
    group     => $apics::group,
    mode      => '0400',
    content   => to_json_pretty(Hash($entries)),
    show_diff => false,
  }

  Class['apics::install'] -> Apics::Gateway_props[$title]
}
