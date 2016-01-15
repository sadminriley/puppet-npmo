# Class: npmo::repo::apt
#
#
class npmo::repo::apt {
  if $module_name != $caller_module_name {
    fail("Module ${name} is private.")
  }

  include ::npmo

  if $::osfamily == 'Debian' and $::npmo::manage_npmo_repo == true {
    apt::source { 'replicated':
      ensure   => present,
      before   => Package['replicated', 'replicated-ui', 'replicated-updater'],
      key      => {
          id => '68386EDB2C8B75CA615A8C985D4781862AFFAC40',
      },
      location => 'https://get.replicated.com/apt',
      notify   => Exec['apt_update'],
      repos    => 'stable',
      release  => 'all',
    }
    apt::source { 'docker':
      ensure   => present,
      before   => Package['docker-engine'],
      key      => {
          id     => '58118E89F3A912897C070ADBF76221572C52609D',
          server => 'hkp://p80.pool.sks-keyservers.net:80',
      },
      location => 'https://apt.dockerproject.org/repo',
      notify   => Exec['apt_update'],
      repos    => 'main',
      release  => "ubuntu-${::lsbdistcodename}",
    }
  }

}
