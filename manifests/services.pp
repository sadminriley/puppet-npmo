# Class: npmo::services
#
#
class npmo::services {
  include ::npmo

  if $::npmo::manage_service {

    service { 'docker':
      ensure     => running,
      enable     => true,
      hasrestart => true,
      hasstatus  => true,
      require    => Package['docker-engine'],
    }

    service { 'replicated':
      ensure     => running,
      enable     => true,
      hasrestart => true,
      hasstatus  => true,
      require    => Package['replicated'],
      subscribe  => File['/etc/replicated.conf', '/etc/replicated-license-retrieval.json'],
    }

    service { 'replicated-ui':
      ensure     => running,
      enable     => true,
      hasrestart => true,
      hasstatus  => true,
      require    => Package['replicated-ui'],
    }

    service { 'replicated-updater':
      ensure     => running,
      enable     => true,
      hasrestart => true,
      hasstatus  => true,
      require    => Package['replicated-updater'],
    }

  }

}
