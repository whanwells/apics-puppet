# @summary Manages a gateway properties file.
#
# @example
#   apics::gateway_props { '/opt/installer/gateway-props.json':
#     ensure  => present,
#     owner   => 'oracle',
#     group   => 'oracle',
#     content => {
#       'nodeInstallDir'  => '/opt/oracle/gateway',
#       'listenIpAddress' => $facts['ipaddress'],
#       'publishAddress'  => $facts['fqdn'],
#     },
#   }
#
# @param ensure
#   Whether the file should exist.
#
# @param path
#   The path to the file.
#
# @param owner
#   The user that owns the file.
#
# @param group
#   The group that owns the file.
#
# @param mode
#   The permissions of the file.
#
# @param content
#   The properties to write to the file.
define apics::gateway_props (
  Enum['present', 'absent'] $ensure,
  String $owner,
  String $group,
  Stdlib::Unixpath $path = $title,
  Stdlib::Filemode $mode = '0400',
  Hash[String, Optional[Variant[String, Integer, Array[String]]]] $content = {}
) {
  $entries = $content.filter |$k, $v| { $v =~ NotUndef }.map |$k, $v| {
    $v ? {
      Array   => [$k, $v],
      default => [$k, String($v)]
    }
  }

  file { $path:
    ensure    => $ensure,
    owner     => $owner,
    group     => $group,
    mode      => $mode,
    show_diff => false,
    content   => to_json_pretty(Hash($entries)),
  }
}
