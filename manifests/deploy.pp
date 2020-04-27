# @summary Manages the gateway node deployment.
#
# @api private
class apics::deploy {
  apics::gateway_exec { 'deploy-install':
    action => 'install',
  }

  apics::gateway_exec { 'deploy-configure':
    action => 'configure',
  }

  apics::gateway_exec { 'deploy-start':
    action => 'start',
  }

  if $apics::join_logical_gateway {
    apics::gateway_exec { 'deploy-join':
      action => 'join',
    }
  }
}
