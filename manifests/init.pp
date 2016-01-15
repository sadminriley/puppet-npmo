# == Class: npmo
#
# Install and configure npmo (On-Site npm).
#
# === Parameters
#
# [*docker_deps*]
#   Array. List of required packages for docker.  This list can be altered if
#   you are managing some / all of these packages elsewhere.  If no dependencies
#   are needed, set this to an empty array.
#
# [*docker_version*]
#   String. Version of docker package to install.  Defaults to "installed".
#
# [*ip_address*]
#   String. IP address to use for replicated when contacting the Internet. Defaults
#   to $::ipaddress.
#
# [*manage_nodejs*]
#   Boolean. Tells module whether or not to manage the repo and version for
#   nodejs.  This uses puppet-nodejs (https://forge.puppetlabs.com/puppet/nodejs).
#   Defaults to "true".
#
# [*manage_nodejs_repo*]
#   Boolean. Tells module whether or not to install the repositories for nodesource.
#   Defaults to "true".
#
# [*manage_npmo_repo*]
#   Boolean. Tells module whether or not to install the repositories for npmo
#   requirements.  Defaults to "true".
#
# [*manage_service*]
#   Boolean. Specify if module should manage the services.  Defaults to true.
#
# [*nodejs_version*]
#   String.  Define the version for Node.js.  This will also dictate to ::nodejs
#   which repo from nodesource to use, and requires 'manage_nodejs' == true.
#   Defaults to 'installed' (0.10 branch)
#
# [*npm_version*]
#   String. Manage the version of npm, using ::nodejs.  Defaults to the version
#   installed with the version of Node.js.
#
# [*npmo_version*]
#   String. Manage the version of npmo, using ::nodejs.  Defaults to 'installed'.
#
# [*pin_docker_version*]
#   Boolean. Uses apt pin (or eventually yum versionlock) to maintain the version
#   of docker.  Requires $docker_version to a regular version number, not
#   "installed" or "latest".  Defaults to "false".
#
# [*proxy_ip*]
#   String.  Proxy IP address for replicated to use for npmo.  Defaults
#   to 'absent'.
#
# [*replicated_version*]
#   String. Loosely controls the version of replicated software.  Currently, this
#    can only be 'installed' or 'latest'.  Defaults to 'installed'.
#
# === Examples
#
#  class { 'npmo':
#    docker_version     = '1.9.1',
#    pin_docker_version = true,
#  }
#
# === Authors
#
# Russell Anderson <russ@greensamurai.com>
#
# === Copyright
#
# Copyright 2016 Russell Anderson.
#
class npmo (
  Array     $docker_deps        = $::npmo::params::docker_deps,
  String[5] $docker_version     = $::npmo::params::docker_version,
  String[5] $ip_address         = $::npmo::params::ip_address,
  Boolean   $manage_nodejs      = $::npmo::params::manage_nodejs,
  Boolean   $manage_nodejs_repo = $::npmo::params::manage_nodejs_repo,
  Boolean   $manage_npmo_repo   = $::npmo::params::manage_npmo_repo,
  Boolean   $manage_service     = $::npmo::params::manage_service,
  String[5] $nodejs_version     = $::npmo::params::nodejs_version,
  String[5] $npm_version        = $::npmo::params::npm_version,
  String[5] $npmo_version       = $::npmo::params::npmo_version,
  Boolean   $pin_docker_version = $::npmo::params::pin_docker_version,
  String    $proxy_ip           = $::npmo::params::proxy_ip,
  String[5] $replicated_version = $::npmo::params::replicated_version,
) inherits ::npmo::params {
  include ::stdlib
  include ::npmo::files
  include ::npmo::install
  include ::npmo::repo
  include ::npmo::services

  if $proxy_ip != 'absent' {
    validate_ip_address($proxy_ip)
  }

  validate_ip_address($ip_address)

  validate_re($replicated_version, ['^installed$', '^latest$'], "replicated_version must be 'installed' or 'latest' in ${module_name}.")

}
