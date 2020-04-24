# @summary Executes a gateway action.
#
# @example
#   apics::gateway_exec { 'install': }
#
# @param action
#   The gateway action to execute.
define apics::gateway_exec (
  Apics::GatewayAction $action = $title,
) {
  if !defined(Class['apics']) {
    fail('You must include the base apics class before using any of its defined resources')
  }

  $creates = $action ? {
    'install'   => "${apics::node_install_dir}/GATEWAY_HOME/installocsg.marker",
    'configure' => "${apics::node_install_dir}/domain/gateway1/ocsgDomainCreation.marker",
    default     => undef,
  }

  $unless = $action ? {
    'start' => 'APIGateway -f gateway-props.json -a status | grep "gateway server: running"',
    default => undef,
  }

  exec { "apics_gateway_exec_${title}":
    command     => "APIGateway -f gateway-props.json -a ${action}",
    user        => $apics::user,
    cwd         => $apics::installer_dir,
    path        => ['/bin', $apics::installer_dir],
    environment => ["JAVA_HOME=${apics::java_home}"],
    creates     => $creates,
    unless      => $unless,
  }

  Class['apics::config'] -> Apics::Gateway_exec[$title]
}
