# @summary Executes a gateway action.
#
# @example
#   apics::gateway_exec { 'install': }
#
# @param action
#   The gateway action to execute.
#
# @param refreshonly
#   Whether or not the command should only run when a dependent object is changed.
define apics::gateway_exec (
  Apics::GatewayAction $action = $title,
  Boolean $refreshonly = false,
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
    'start' => "ss -tnl4 | grep '${apics::listen_ip_address}:${apics::gateway_managed_server_ssl_port}'",
    'join'  => "cat ${apics::node_install_dir}/logs/status.log | grep 'join isSuccess: ok'",
    default => undef,
  }

  exec { "apics_gateway_exec_${title}":
    command     => "APIGateway -f gateway-props.json -a ${action}",
    user        => $apics::user,
    cwd         => $apics::installer_dir,
    path        => ['/bin', '/usr/sbin', $apics::installer_dir],
    environment => ["JAVA_HOME=${apics::java_home}"],
    creates     => $creates,
    unless      => $unless,
    timeout     => 0,
    refreshonly => $refreshonly,
  }

  Class['apics::config'] -> Apics::Gateway_exec[$title]
}
