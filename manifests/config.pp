# @summary Manages the gateway node configuration.
#
# @api private
class apics::config(
  String $user,
  String $group,
  Stdlib::Unixpath $gateway_props_path,
  Optional[Integer] $logical_gateway_id,
  Stdlib::HTTPSUrl $management_service_url,
  Stdlib::HTTPSUrl $idcs_url,
  String $request_scope,
  String $gateway_node_name,
  Optional[String] $gateway_node_description,
  Stdlib::IP::Address::V4 $listen_ip_address,
  Stdlib::Host $publish_address,
  Stdlib::Unixpath $node_install_dir,
  Apics::ExecutionMode $gateway_execution_mode,
  Integer $heap_size_gb,
  Integer $maximum_heap_size_gb,
  Stdlib::Port $gateway_managed_server_port,
  Stdlib::Port $gateway_managed_server_ssl_port,
  Stdlib::Port $node_manager_port,
  Stdlib::Port $coherence_port,
  Stdlib::Port $gateway_db_port,
  Stdlib::Port $gateway_admin_server_port,
  Stdlib::Port $gateway_admin_server_ssl_port,
) {
  # If logical_gateway_id is defined, turn it into a string
  $_logical_gateway_id = $logical_gateway_id ? {
    Integer => String($logical_gateway_id),
    default => undef,
  }

  $gateway_props = {
    'logicalGatewayId'          => $_logical_gateway_id,
    'managementServiceUrl'      => $management_service_url,
    'idcsUrl'                   => $idcs_url,
    'requestScope'              => $request_scope,
    'gatewayNodeName'           => $gateway_node_name,
    'gatewayNodeDescription'    => $gateway_node_description,
    'listenIpAddress'           => $listen_ip_address,
    'publishAddress'            => $publish_address,
    'nodeInstallDir'            => $node_install_dir,
    'gatewayExecutionMode'      => $gateway_execution_mode,
    'heapSizeGb'                => String($heap_size_gb),
    'maximumHeapSizeGb'         => String($maximum_heap_size_gb),
    'gatewayMServerPort'        => String($gateway_managed_server_port),
    'gatewayMServerSSLPort'     => String($gateway_managed_server_ssl_port),
    'nodeManagerPort'           => String($node_manager_port),
    'coherencePort'             => String($coherence_port),
    'gatewayDBPort'             => String($gateway_db_port),
    'gatewayAdminServerPort'    => String($gateway_admin_server_port),
    'gatewayAdminServerSSLPort' => String($gateway_admin_server_ssl_port),
  }

  file { $gateway_props_path:
    ensure  => present,
    owner   => $user,
    group   => $group,
    mode    => '0440',
    content => to_json_pretty($gateway_props, true),
  }
}
