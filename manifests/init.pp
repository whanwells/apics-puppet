# @summary Manages an Oracle API Platform gateway node.
#
# When declared with the minimum required attributes, Puppet will:
#
# - Create the gateway node user and group.
# - Download and extract the gateway node installer.
# - Configure the `gateway-props.json` file.
#
# @example
#   class { 'apics':
#     gateway_node_name      => 'Test Node',
#     management_service_url => 'https://test.apiplatform.ocp.example.com',
#     idcs_url               => 'https://idcs.example.com/oauth2/v1/token',
#     request_scope          => 'https://apiplatform.example.com.apiplatform offline_access',
#     installer_source       => '/path/to/ApicsGatewayInstaller.zip',
#   }
#
# @param user
#   The name of the gateway node user. Default: 'oracle'.
#
# @param group
#   The name of the gateway node group. Default: 'oracle'.
#
# @param manage_user
#   Whether or not the gateway node user will be managed. Default: `true`.
#
# @param manage_group
#   Whether or not the gateway node user will be managed. Default: `true`.
#
# @param basedir
#   The root directory of the gateway node directory tree. Default: '/opt/oracle'.
#
# @param installer_source
#   The location of the gateway node installer.
#
# @param installer_target
#   The location where the gateway node installer will be copied. Default: '/tmp/ApicsGatewayInstaller.zip'.
#
# @param installer_cleanup
#   Whether or not the installer file will be removed after extraction. Default: `false`.
#
# @param logical_gateway_id
#   The ID of the logical gateway the node registers to. Default: `undef`.
#
# @param management_service_url
#   The URL of the management service instance that the node registers to.
#
# @param idcs_url
#   The URL of the IDCS instance the node uses to communicate with the management service.
#
# @param request_scope
#   The IDCS scope the node uses to communicate with the management service.
#
# @param gateway_node_name
#   The name of the gateway node.
#
# @param gateway_node_decription
#   The description of the gateway node. Default: `undef`.
#
# @param listen_ip_address
#   The internal IP used for the configuration of the node domain. Default: `$facts['ipaddress']`.
#
# @param publish_address
#   The public IP/hostname displayed in the management service for the node's URL. Default: `$facts['fqdn'].
#
# @param gateway_execution_mode
#   The execution mode of the gateway node. Valid options: 'Development', 'Production'. Default: 'Development'.
#
# @param heap_size_gb
#   The memory to be used by the admin and managed servers (in GB). Default: 2.
#
# @param maximum_heap_size_gb
#   The maximum memory allowed to be used by the admin and managed servers (in GB). Default: 4.
#
# @param gateway_managed_server_port
#   The HTTP port of the managed gateway node. Default: 8011.
#
# @param gateway_managed_server_ssl_port
#   The HTTPS port of the managed gateway node. Default: 9022.
#
# @param node_manager_port
#   The port used by the node manager. Default: 5556.
#
# @param coherence_port
#   The Coherence port used by the gateway node domain. Default: 8088.
#
# @param gateway_db_port
#   The Java DB port used by the gateway. Default: 1527.
#
# @param gateway_admin_server_port
#   The HTTP port of the gateway node admin console. Default: 8001.
#
# @param gateway_admin_server_ssl_port
#   The HTTP port of the gateway node admin console. Default: 9021.
class apics(
  String $user,
  String $group,
  Boolean $manage_user,
  Boolean $manage_group,
  Stdlib::Unixpath $basedir,
  Stdlib::Filesource $installer_source,
  Stdlib::Unixpath $installer_target,
  Boolean $installer_cleanup,
  Optional[Integer] $logical_gateway_id,
  Stdlib::HTTPSUrl $management_service_url,
  Stdlib::HTTPSUrl $idcs_url,
  String $request_scope,
  String $gateway_node_name,
  Optional[String] $gateway_node_description,
  Stdlib::IP::Address::V4 $listen_ip_address,
  Stdlib::Host $publish_address,
  Enum['Development', 'Production'] $gateway_execution_mode,
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
  $installer_extract_path = "${basedir}/installer"
  $gateway_props_path = "${installer_extract_path}/gateway-props.json"
  $node_install_dir = "${basedir}/gateway"

  class { 'apics::install':
    user                   => $user,
    group                  => $group,
    manage_user            => $manage_user,
    manage_group           => $manage_group,
    basedir                => $basedir,
    installer_source       => $installer_source,
    installer_target       => $installer_target,
    installer_extract_path => $installer_extract_path,
    installer_cleanup      => $installer_cleanup,
  }

  class { 'apics::config':
    user                            => $user,
    group                           => $group,
    gateway_props_path              => $gateway_props_path,
    logical_gateway_id              => $logical_gateway_id,
    management_service_url          => $management_service_url,
    idcs_url                        => $idcs_url,
    request_scope                   => $request_scope,
    gateway_node_name               => $gateway_node_name,
    gateway_node_description        => $gateway_node_description,
    listen_ip_address               => $listen_ip_address,
    publish_address                 => $publish_address,
    node_install_dir                => $node_install_dir,
    gateway_execution_mode          => $gateway_execution_mode,
    heap_size_gb                    => $heap_size_gb,
    maximum_heap_size_gb            => $maximum_heap_size_gb,
    gateway_managed_server_port     => $gateway_managed_server_port,
    gateway_managed_server_ssl_port => $gateway_managed_server_ssl_port,
    node_manager_port               => $node_manager_port,
    coherence_port                  => $coherence_port,
    gateway_db_port                 => $gateway_db_port,
    gateway_admin_server_port       => $gateway_admin_server_port,
    gateway_admin_server_ssl_port   => $gateway_admin_server_ssl_port,
  }

  contain apics::install
  contain apics::config
}
