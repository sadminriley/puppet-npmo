# Class: npmo::params
#
#
class npmo::params {
  include ::stdlib

  $docker_deps = [
    "linux-image-extra-${::kernelrelease}",
    'apparmor',
    'apt-transport-https',
    'ca-certificates',
    'curl',
    'linux-image-extra-virtual',
  ]
  $docker_version = 'installed'
  $ip_address = $::ipaddress
  $manage_repo = true
  $pin_docker_version = false
  $proxy_ip = ''
  $replicated_version = 'installed'

}
