# apics

#### Table of Contents

1. [Description](#description)
2. [Setup - The basics of getting started with apics](#setup)
    * [What apics affects](#what-apics-affects)
    * [Beginning with apics](#beginning-with-apics)
3. [Usage - Configuration options and additional functionality](#usage)
4. [Limitations - OS compatibility, etc.](#limitations)
5. [Development - Guide for contributing to the module](#development)

## Description

The apics module installs and configures an Oracle API Platform gateway node.

## Setup

### What apics affects

When declared with the minimum required attributes, Puppet will attempt to:

* Install the `unzip` package and Oracle JDK
* Create the gateway node user and group
* Download and extract the gateway node installer
* Configure the `gateway-props.json` file
* Deploy and start the gateway node

### Beginning with apics

To install a gateway node, declare the `apics` class:

```puppet
class { 'apics':
  installer_source       => '/path/to/ApicsGatewayInstaller.zip',
  java_package_source    => '/path/to/jdk.rpm',
  java_package_version   => '8u251',
  gateway_admin_password => 'Welcome1',
}
```

## Usage

### Registering the gateway node

To ensure the node can be registered with its logical gateway, set the appropriate parameters:

```puppet
class { 'apics':
  logical_gateway_id     => 100,
  management_service_url => 'https://test.apiplatform.ocp.example.com',
  idcs_url               => 'https://idcs.example.com/oauth2/v1/token',
  request_scope          => 'https://apiplatform.example.com.apiplatform offline_access',
}
```

### Managing the gateway user and group

By default, the `apics` module will create a user and group named _oracle_.

To specify a different name for either resource, use the `user` and `group` parameters:

```puppet
class { 'apics':
  user  => 'foo',
  group => 'bar',
}
```

To prevent Puppet from managing the user or group, use the `manage_user` and `manage_group` parameters:

```puppet
class { 'apics':
  manage_user  => false,
  manage_group => false,
}
```

## Reference

See [REFERENCE.md](https://github.com/whanwells/apics-puppet/blob/master/REFERENCE.md).

## Limitations

For a list of supported operating systems, see [metadata.json](https://github.com/whanwells/apics-puppet/blob/master/metadata.json).

## Development

Acceptance tests for this module leverage [puppet_litmus](https://github.com/puppetlabs/puppet_litmus).
