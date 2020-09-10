# apics

## Table of Contents

1. [Description](#description)
1. [Setup - The basics of getting started with apics](#setup)
    * [Setup requirements](#setup-requirements)
    * [Beginning with apics](#beginning-with-apics)
1. [Usage - Configuration options and additional functionality](#usage)
1. [Limitations - OS compatibility, etc.](#limitations)
1. [Development - Guide for contributing to the module](#development)

## Description

The apics module provides types and tasks for managing an Oracle API Platform
gateway node.

## Setup

### Setup Requirements

Users of this module are responsible for the following prerequisites:

* Installing the `unzip` package
* Installing a [certified Oracle JDK](https://docs.oracle.com/en/cloud/paas/api-platform-cloud/apfad/system-requirements-premise-gateway-installation.html#GUID-45E866FB-A8E3-4DF3-A031-21ADBADC674D)
* Creating the gateway node user and group

### Beginning with apics

Extract the gateway node installer.

```puppet
apics::gateway_installer { '/opt/installer':
  ensure => present,
  owner  => 'oracle',
  group  => 'oracle',
  source => '/tmp/ApicsGatewayInstaller.zip',
}
```

Create the gateway property file in the installer directory.

```puppet
apics::gateway_props { '/opt/installer/gateway-props.json':
  ensure  => present,
  owner   => 'oracle',
  group   => 'oracle',
  content => {
    'nodeInstallDir'  => '/opt/oracle/gateway',
    'listenIpAddress' => $facts['ipaddress'],
    # ...
  },
}
```

## Usage

### Executing gateway actions

Use the `apics::gateway` task to execute gateway actions on nodes.

```bash
bolt task run apics::gateway --targets node1 java_home=/usr/java/default path=/opt/installer file=gateway-props.json action=status
```

## Reference

See [REFERENCE.md](https://github.com/whanwells/apics-puppet/blob/master/REFERENCE.md).

## Limitations

For a list of supported operating systems, see [metadata.json](https://github.com/whanwells/apics-puppet/blob/master/metadata.json).

## Development

Acceptance tests for this module leverage [puppet_litmus](https://github.com/puppetlabs/puppet_litmus).
