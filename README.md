# npmo
[![Build Status](https://travis-ci.org/x3dfxjunkie/puppet-npmo.svg?branch=master)](https://travis-ci.org/x3dfxjunkie/puppet-npmo)

#### Table of Contents

1. [Overview](#overview)
3. [Setup](#setup)
    * [What npmo affects](#what-npmo-affects)
    * [Setup requirements](#setup-requirements)
    * [Beginning with npmo](#beginning-with-npmo)
4. [Usage - Configuration options and additional functionality](#usage)
5. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
5. [Limitations - OS compatibility, etc.](#limitations)
6. [Development - Guide for contributing to the module](#development)

## Overview

The npmo module installs the Node.js module npmo (npm On-Site), along with it's
dependencies.

## Module Description

If applicable, this section should have a brief description of the technology
the module integrates with and what that integration enables. This section
should answer the questions: "What does this module *do*?" and "Why would I use
it?"

If your module has a range of functionality (installation, configuration,
management, etc.) this is the time to mention it.

## Setup

### What npmo affects

* Docker
* Repicated
* Possibly Node.js and npm packages / binaries

### Setup Requirements

Future parser, or puppet 4, is required.

### Beginning with npmo

Basic usage

~~~puppet
class { 'npmo': }
~~~

## Usage

### Using with a proxy

~~~puppet
class { 'npmo':
  proxy_ip => '192.168.1.1',
}
~~~

### Manually specify which IP address to use

~~~puppet
class { 'npmo':
  ip_address => '192.168.1.100',
}
~~~

## Reference

- [**Public Classes**](#public-classes)
    - [Class: npmo](#class-npmo)
- [**Private Classes**](#private-classes)
    - [Class: npmo::files](#class-npmo_files)
    - [Class: npmo::install](#class-npmo_install)
    - [Class: npmo::params](#class-npmo_params)
    - [Class: npmo::init](#class-npmo_init)
    - [Class: npmo::repo::apt](#class-npmo_repo_apt)
    - [Class: npmo::repo](#class-npmo_repo)
    - [Class: npmo::files](#class-npmo_files)
    - [Class: npmo::services](#class-npmo_services)

### Public Classes

#### Class: `npmo`

Basic setup for `npmo`.  With all the default options, puppet:
- Installs the needed repositories
- Installs the requirements
    - Docker-engine
        - linux-image-extra-${::kernelrelease}
        - apparmor
        - apt-transport-https
        - ca-certificates
        - curl
        - linux-image-extra-virtual
    - Replicated, replicated-ui, Replicated-updater
    - Node.js, npm

**Parameters withing `npmo`:**

##### `docker_deps`

Array of Strings. Sets an array of docker requirements.  You can override the default list, or remove
it entirely, with this if they are specified elsewhere.

##### `docker_version`

String. Specify the version of docker-engine to install.  This defaults to 'installed',
but can be any string that `package` understands for the `ensure` parameter.

##### `ip_address`

String. If the server has multiple IP addresses, the one to listen on can be specified here.
Defaults to the fact `::ipaddress`.

##### `manage_repo`

Boolean. Manages the repository sources for apt (and eventually yum).  If set to `false`,
no repos will be added.

##### `pin_docker_version`

Boolean. Uses apt-pin (and eventually yum versionlock) to ensure the version of
docker.  This also requires that `docker_version` be an actual version number.

##### `proxy_ip`

String.  IP address of a proxy server to use.  Defaults to an empty string (unused).

##### `replicated_version`

String.  Version of the replicated packages to install.  This currently only accepts
`installed` or `latest`, and defaults to `installed`.

## Limitations

Currently, this only works with Ubuntu 14 and puppet 3.7+ (with future parser).

## Development

- Fork
- Change (be sure tests pass!)
- PR

## Release Notes/Contributors/Etc **Optional**

### Todo

- RHEL support

### Testing

```shell
sudo apt-get install bundler ruby-dev
sudo gem install travis --no-ri --no-rdoc
bundle install --without development
travis lint --skip-completion-check
```

One-time with system libraries (puppet v4):
```shell
bundle exec rake validate
bundle exec rake spec
```

One-time with system libraries (puppet v3):
```shell
bundle exec rake validate FUTURE_PARSER='yes'
bundle exec rake spec FUTURE_PARSER='yes'
```

<!-- Travis-style gauntlet:
```shell
sudo gem install bundler wwtd --no-ri --no-rdoc
curl -sSL https://rvm.io/mpapis.asc | sudo gpg --import -
curl -sL https://get.rvm.io | sudo bash -s stable
sudo usermod -a -G rvm `whoami`
exit
```
```shell
for rvm in $(grep -A5 ^rvm .travis.yml | grep -B5 -oP '\d\.\d\.\d'); do
    rvm install $rvm
    rvm $rvm do gem install bundler --no-ri --no-rdoc
done
rvm use system
wwtd

``` -->