# Class: npmo::params
#
#
class npmo::params {

  $docker_version = undef
  if $docker_version != undef {
    assert_type(String[5], $docker_version)
  }

  $manage_repo = true
  validate_boolean($manage_repo)

}
