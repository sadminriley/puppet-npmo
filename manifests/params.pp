# Class: npmo::params
#
#
class npmo::params {
  include ::stdlib

  $docker_deps = [
    "linux-image-extra-${::kernelrelease}",
    'apparmor',
    # 'apt-transport-https',                  # provided by ::nodejs
    # 'ca-certificates',                      # provided by ::nodejs
    'curl',
    'linux-image-extra-virtual',
  ]
  $docker_version = 'installed'
  $ip_address = $::ipaddress
  $manage_nodejs = true
  $manage_repo = true
  $manage_service = true
  $nodejs_version = 'installed'
  $npm_version = 'installed'
  $npmo_version = 'installed'
  $pin_docker_version = false
  $proxy_ip = 'absent'
  $replicated_version = 'installed'

}
