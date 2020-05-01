# @summary Manages the gateway node configuration.
#
# @api private
class apics::config {
  apics::gateway_props { "${apics::installer_dir}/gateway-props.json":
    ensure  => present,
    content => {
      'managementServiceUrl'      => $apics::management_service_url,
      'idcsUrl'                   => $apics::idcs_url,
      'requestScope'              => $apics::request_scope,
      'gatewayNodeName'           => $apics::gateway_node_name,
      'gatewayNodeDescription'    => $apics::gateway_node_description,
      'listenIpAddress'           => $apics::listen_ip_address,
      'publishAddress'            => $apics::publish_address,
      'nodeInstallDir'            => $apics::node_install_dir,
      'gatewayExecutionMode'      => $apics::gateway_execution_mode,
      'heapSizeGb'                => $apics::heap_size_gb,
      'maximumHeapSizeGb'         => $apics::maximum_heap_size_gb,
      'gatewayMServerPort'        => $apics::gateway_managed_server_port,
      'gatewayMServerSSLPort'     => $apics::gateway_managed_server_ssl_port,
      'nodeManagerPort'           => $apics::node_manager_port,
      'coherencePort'             => $apics::coherence_port,
      'gatewayDBPort'             => $apics::gateway_db_port,
      'gatewayAdminServerPort'    => $apics::gateway_admin_server_port,
      'gatewayAdminServerSSLPort' => $apics::gateway_admin_server_ssl_port,
      'gatewayadminName'          => $apics::gateway_admin_username,
      'gatewayadminPassword'      => $apics::gateway_admin_password,
      'clientId'                  => $apics::client_id,
      'clientSecret'              => $apics::client_secret,
      'gatewayManagerUser'        => $apics::gateway_manager_username,
      'gatewayManagerPassword'    => $apics::gateway_manager_password,
      'gatewayRuntimeUser'        => $apics::gateway_runtime_username,
      'gatewayRuntimePassword'    => $apics::gateway_runtime_password,
    },
  }
}
