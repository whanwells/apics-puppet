# @summary Manages an Oracle API Platform gateway node.
#
# When declared with the minimum required attributes, Puppet will:
#
# - Create the gateway node user and group.
# - Download and extract the gateway node installer.
# - Configure the `gateway-props.json` file.
#
# @example
#   include apics
#
# @param user
#   The name of the gateway node user. Default: 'oracle'.
#
# @param group
#   The name of the gateway node group. Default: 'oracle'.
#
# @param manage_user
#   Whether or not the gateway node user will be managed. Default: true.
#
# @param manage_group
#   Whether or not the gateway node user will be managed. Default: true.
#
# @param manage_unzip_package
#   Whether the unzip package should be managed. Default: true.
#
# @param basedir
#   The root directory of the gateway node directory tree. Default: '/opt/oracle'.
#
# @param installer_source
#   The location of the gateway node installer. Default: '/tmp/ApicsGatewayInstaller.zip'.
#
# @param installer_target
#   The location where the gateway node installer will be copied. Default: '/tmp/ApicsGatewayInstaller.zip'.
#
# @param installer_cleanup
#   Whether or not the installer file will be removed after extraction. Default: false.
#
# @param logical_gateway_id
#   The ID of the logical gateway the node registers to. Default: 100.
#
# @param logical_gateway
#   The name of the logical gateway the node registers to. Default: undef.
#
# @param management_service_url
#   The URL of the management service instance that the node registers to. Default: undef.
#
# @param idcs_url
#   The URL of the IDCS instance the node uses to communicate with the management service. Default: undef.
#
# @param request_scope
#   The IDCS scope the node uses to communicate with the management service. Default: undef.
#
# @param gateway_node_name
#   The name of the gateway node. Default: 'hostname' fact.
#
# @param gateway_node_description
#   The description of the gateway node. Default: undef.
#
# @param listen_ip_address
#   The internal IP used for the configuration of the node domain. Default: 'ipaddress' fact.
#
# @param publish_address
#   The public IP/hostname displayed in the management service for the node's URL. Default: 'fqdn' fact.
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
#
# @param gateway_admin_username
#   The username of the WebLogic administrator. Default: 'weblogic'.
#
# @param gateway_admin_password
#   The password of the Weblogic administrator. Default: 'Welcome1'.
#
# @param java_home
#   The path to the JAVA_HOME directory. Default: '/usr/java/default'.
class apics(
  String $user,
  String $group,
  Boolean $manage_user,
  Boolean $manage_group,
  Boolean $manage_unzip_package,
  Stdlib::Unixpath $basedir,
  Stdlib::Filesource $installer_source,
  Stdlib::Unixpath $installer_target,
  Boolean $installer_cleanup,
  Integer $logical_gateway_id,
  Optional[String] $logical_gateway,
  Optional[Stdlib::HTTPSUrl] $management_service_url,
  Optional[Stdlib::HTTPSUrl] $idcs_url,
  Optional[String] $request_scope,
  String $gateway_node_name,
  Optional[String] $gateway_node_description,
  Stdlib::IP::Address::V4 $listen_ip_address,
  Stdlib::Host $publish_address,
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
  String $gateway_admin_username,
  String $gateway_admin_password,
  Stdlib::Unixpath $java_home,
) {
  $installer_dir = "${basedir}/installer"
  $node_install_dir = "${basedir}/gateway"

  $installer = "${installer_dir}/APIGateway"
  $gateway_props_path = "${installer_dir}/gateway-props.json"

  contain apics::install
  contain apics::config
  contain apics::deploy
}
