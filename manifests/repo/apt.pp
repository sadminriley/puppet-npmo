# Class: npmo::repo::apt
#
#
class npmo::repo::apt {
  include ::npmo
  include ::stdlib

  assert_private()

  if $::osfamily == 'Debian' and $::npmo::manage_repo == true {
    apt::source { 'replicated':
      ensure   => present,
      before   => Package['replicated', 'replicated-ui', 'replicated-updater'],
      key      => {
          id => '68386EDB2C8B75CA615A8C985D4781862AFFAC40',
      },
      location => 'https://get.replicated.com/apt',
      repos    => 'all',
      release  => 'stable',
    }
  }

}
