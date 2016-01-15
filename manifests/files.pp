# Class: npmo::files
#
#
class npmo::files {
  if $module_name != $caller_module_name {
    fail("Module ${name} is private.")
  }

  include ::npmo

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

  file { '/etc/replicated-license-retrieval.json':
    ensure  => file,
    content => template("${module_name}/replicated-license-retrieval.json.erb"),
    group   => 'root',
    mode    => '0444',
    owner   => 'root',
  }

}
