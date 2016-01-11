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
    require => [File['/etc/replicated.conf', '/etc/replicated-license-retrieval.json'], Package['docker-engine']],
  }

  # Node.js
  if $::npmo::manage_nodejs == true {
    # Figure out which nodesource repo to use
    if $::npmo::nodejs_version =~ /^0\.12/ {
      $repo_url_suffix = assert_type(String[3], '0.12')
    }
    elsif $::npmo::nodejs_version =~ /^4\.\d+/ {
      $repo_url_suffix = assert_type(String[3], '4.x')
    }
    elsif $::npmo::nodejs_version =~ /^5\.\d+/ {
      $repo_url_suffix = assert_type(String[3], '5.x')
    }
    else {
      $repo_url_suffix = assert_type(String[4], '0.10')
    }
    if $::npmo::npm_version =~ /^\d+\./ {
      class { 'nodejs':
        manage_package_repo   => true,
        nodejs_package_ensure => $::npmo::nodejs_version,
        npm_package_name      => false,
        repo_proxy            => $::npmo::proxy_ip,
        repo_pin              => '1002',
        repo_url_suffix       => $repo_url_suffix,
      } ->
      package { 'npm':
        ensure   => $npmo::npm_version,
        provider => 'npm',
      }
      Package['npm'] -> Package <| provider == 'npm' |>
    } else {
      class { 'nodejs':
        manage_package_repo   => true,
        nodejs_package_ensure => $::npmo::nodejs_version,
        repo_proxy            => $::npmo::proxy_ip,
        repo_pin              => '1002',
        repo_url_suffix       => $repo_url_suffix,
      }
    }
  }

  # npmo
  package { 'npmo':
    ensure          => $::npmo::npmo_version,
    install_options => ['--ignore-scripts'],
    provider        => 'npm',
    require         => Class['::nodejs'],
  }

}
