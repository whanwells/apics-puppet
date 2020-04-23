# @summary Manages the gateway node configuration.
#
# @api private
class apics::config {
  apics::gateway_props { $apics::gateway_props_path:
    ensure => present,
    owner  => $apics::user,
    group  => $apics::group,
    mode   => '0440',
    props  => {
      'logicalGatewayId'          => $apics::logical_gateway_id,
      'logicalGateway'            => $apics::logical_gateway,
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
    },
  }
}
