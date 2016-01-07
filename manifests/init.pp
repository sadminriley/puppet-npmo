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
# [*manage_repo*]
#   Boolean. Tells module whether or not to install the repositories for npmo
#   requirements.  Defaults to "true".
#
# [*pin_docker_version*]
#   Boolean. Uses apt pin (or eventually yum versionlock) to maintain the version
#   of docker.  Requires $docker_version to a regular version number, not
#   "installed" or "latest".  Defaults to "false".
#
# [*proxy_ip*]
#   String.  Proxy IP address for replicated to use for npmo.  Defaults
#   to empty.
#
# [*replicated_version*]
#   String. Loosely controls the version of replicated software.  Currently, this
#    can only be 'installed' or 'latest'.  Defaults to 'installed'.
#
# === Variables
#
# Here you should define a list of variables that this module would require.
#
# [*sample_variable*]
#   Explanation of how this variable affects the function of this class and if
#   it has a default. e.g. "The parameter enc_ntp_servers must be set by the
#   External Node Classifier as a comma separated list of hostnames." (Note,
#   global variables should be avoided in favor of class parameters as
#   of Puppet 2.6.)
#
# === Examples
#
#  class { 'npmo':
#    servers => [ 'pool.ntp.org', 'ntp.local.company.com' ],
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
  Boolean   $manage_repo        = $::npmo::params::manage_repo,
  Boolean   $pin_docker_version = $::npmo::params::pin_docker_version,
  String    $proxy_ip           = $::npmo::params::proxy_ip,
  String[5] $replicated_version = $::npmo::params::replicated_version,
) inherits ::npmo::params {
  include ::stdlib

  if $proxy_ip != '' {
    validate_ip_address($proxy_ip)
  }

  validate_ip_address($ip_address)

  validate_re($replicated_version, ['^installed$', '^latest$'], "replicated_version must be 'installed' or 'latest' in ${module_name}.")

  if $manage_repo == true {
    include ::npmo::repo
  }

}
