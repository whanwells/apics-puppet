# apics

#### Table of Contents

1. [Description](#description)
2. [Setup - The basics of getting started with apics](#setup)
    * [What apics affects](#what-apics-affects)
    * [Setup requirements](#setup-requirements)
    * [Beginning with apics](#beginning-with-apics)
3. [Usage - Configuration options and additional functionality](#usage)
4. [Limitations - OS compatibility, etc.](#limitations)
5. [Development - Guide for contributing to the module](#development)

## Description

The apics module installs and configures an Oracle API Platform gateway node.

## Setup

### What apics affects

* The gateway user, group, directories, and files
* The `unzip` package

### Setup Requirements

Users of this module are responsible for:

- Managing a [supported JDK](https://docs.oracle.com/en/cloud/paas/api-platform-cloud/apfad/system-requirements-premise-gateway-installation.html#GUID-45E866FB-A8E3-4DF3-A031-21ADBADC674D) and ensuring the `JAVA_HOME` environment variable is set

### Beginning with apics

To install a gateway node with the minimum required parameters, declare the `apics` class:

```puppet
class { 'apics':
  management_service_url => 'https://test.apiplatform.ocp.example.com',
  idcs_url               => 'https://idcs.example.com/oauth2/v1/token',
  request_scope          => 'https://apiplatform.example.com.apiplatform offline_access',
  installer_source       => '/path/to/ApicsGatewayInstaller.zip',
}
```

## Usage

### Managing the gateway node user and group

By default, the `apics` module will create a user and group named _oracle_.

To specify a different name for either resource, use the `user` and `group` parameters:

```puppet
class { 'apics':
  user                   => 'foo',
  group                  => 'bar',
  management_service_url => 'https://test.apiplatform.ocp.example.com',
  idcs_url               => 'https://idcs.example.com/oauth2/v1/token',
  request_scope          => 'https://apiplatform.example.com.apiplatform offline_access',
  installer_source       => '/path/to/ApicsGatewayInstaller.zip',
}
```

To prevent Puppet from managing the user or group, use the `manage_user` and `manage_group` parameters:

```puppet
class { 'apics':
  manage_user            => false,
  manage_group           => false,
  management_service_url => 'https://test.apiplatform.ocp.example.com',
  idcs_url               => 'https://idcs.example.com/oauth2/v1/token',
  request_scope          => 'https://apiplatform.example.com.apiplatform offline_access',
  installer_source       => '/path/to/ApicsGatewayInstaller.zip',
}
```

### Using a network file share for the gateway node installer

If the gateway node installer is located on a network file share, set the `installer_source` and `installer_target` parameters to the same value to prevent copying the file.

```puppet
class { 'apics':
  management_service_url => 'https://test.apiplatform.ocp.example.com',
  idcs_url               => 'https://idcs.example.com/oauth2/v1/token',
  request_scope          => 'https://apiplatform.example.com.apiplatform offline_access',
  installer_source       => '/path/to/ApicsGatewayInstaller.zip',
  installer_target       => '/path/to/ApicsGatewayInstaller.zip',
}
```

## Reference

See [REFERENCE.md](https://github.com/whanwells/apics-puppet/blob/master/REFERENCE.md).

## Limitations

For a list of supported operating systems, see [metadata.json](https://github.com/whanwells/apics-puppet/blob/master/metadata.json).

## Development

Acceptance tests for this module leverage [puppet_litmus](https://github.com/puppetlabs/puppet_litmus).
