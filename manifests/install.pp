# Class: npmo::install
#
#
class npmo::install {
  include ::npmo
  include ::stdlib

  # Docker
  if is_array($::npmo::docker_deps) {
    if $::npmo::docker_deps != [] {
      package { $::npmo::docker_deps:
        ensure => installed,
        before => Package['docker-engine'],
      }
    }
  }

  package { 'docker-engine':
    ensure => $::npmo::docker_version,
  }

  # Replicated
  package { [
    'replicated',
    'replicated-ui',
    'replicated-updater',
    ]:
    ensure  => $::npmo::replicated_version,
    require => [File['/etc/replicated.conf'], Package['docker-engine']],
  }

  file { '/etc/replicated.conf':
    ensure  => file,
    content => template("${module_name}/replicated.conf.erb"),
    group   => 'root',
    mode    => '0444',
    owner   => 'root',
  }

  file { '/etc/logrotate.d/replicated':
    ensure  => file,
    content => template("${module_name}/logrotate.d_replicated.erb"),
    group   => 'root',
    mode    => '0444',
    owner   => 'root',
    require => Package['replicated', 'replicated-ui', 'replicated-updater'],
  }

}
