# Changelog

All notable changes to this project will be documented in this file.

## Release 0.8.0

**Fixed**

- Deadlock when starting a node
- Handle optional task parameters with nil values

**Changed**

- Use an array instead of hash for the `apics::gateway` task `keyvalue` parameter

**Removed**

- `apics::gateway` task `timeout` parameter

## Release 0.7.0

**Added**

- `apics::gateway_props` `Sensitive` property value support

## Release 0.6.0

**Added**

- `apics::gateway_installer` defined type
- `apics::gateway` task

**Changed**

- Refactor `apics::gateway_props` defined type

**Removed**

- `apics` class

## Release 0.5.3

**Changed**

- Don't write `apics::logical_gateway` or `apics::logical_gateway_id` to `gateway-props.json`

**Fixed**

- Change 'create' action to 'creategateway'
- Only attempt to create a logical gateway when one hasn't been joined

## Release 0.5.2

**Added**

- `apics::gateway_exec::refreshonly` parameter

**Fixed**

- Allow logical gateways to be created before joining

## Release 0.5.1

**Changed**

- Disable timeout in gateway `exec` resources

## Release 0.5.0

**Added**

- Logical gateway registration

## Release 0.4.0

**Added**

- Management of the `unzip` package
- Management of the Oracle JDK
- Deployment of the gateway node

**Changed**

- Hide gateway prop file diffs

## Release 0.3.0

**Added**

- `apics::gateway_props` defined type

## Release 0.2.0

**Added**

- `apics::logical_gateway` parameter for defining the name of the logical gateway the node will join

**Changed**

- Default `apics::logical_gateway_id` to 100

## Release 0.1.0

**Added**

- `apics` class for managing gateway nodes
