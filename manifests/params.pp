# Class: npmo::params
#
#
class npmo::params {

  $docker_version = 'installed'
  assert_type(String[5], $docker_version)

  $manage_repo = true
  assert_type(Boolean, $manage_repo)

  $pin_docker_version = false
  assert_type(Boolean, $pin_docker_version)

}
