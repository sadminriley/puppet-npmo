# == Class: npmo
#
# Install and configure npmo (On-Site npm).
#
# === Parameters
#
# [*docker_version*]
#   String. Version of docker package to install.  Defaults to "installed".
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
# === Variables
#
# Here you should define a list of variables that this module would require.
#
# [*sample_variable*]
#   Explanation of how this variable affects the funtion of this class and if
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
  String[5] $docker_version     = $::npmo::params::docker_version,
  Boolean   $manage_repo        = $::npmo::params::manage_repo,
  Boolean   $pin_docker_version = $::npmo::params::pin_docker_version,
) inherits ::npmo::params {

  if $manage_repo == true {
    include ::npmo::repo
  }

}
