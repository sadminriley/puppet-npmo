require 'spec_helper'
describe 'npmo' do

  let :facts do {
    :ipaddress              => '127.0.0.1',
    :kernelrelease          => '3.13.0-61-generic',
    :lsbdistcodename        => 'trusty',
    :lsbdistid              => 'Ubuntu',
    :operatingsystem        => 'Ubuntu',
    :operatingsystemrelease => '14.04',
    :osfamily               => 'Debian',
    }
  end

  context 'with defaults for all parameters' do
    it { is_expected.to contain_class('npmo') }
    it { is_expected.to contain_class('npmo::files') }
    it { is_expected.to contain_class('npmo::install') }
    it { is_expected.to contain_class('npmo::params') }
    it { is_expected.to contain_class('npmo::repo') }
    it { is_expected.to contain_class('npmo::repo::apt') }
    it { is_expected.to contain_class('npmo::services') }
    it { is_expected.to contain_apt__source('replicated').with(
      :location => 'https://get.replicated.com/apt',
      :key => { "id" => '68386EDB2C8B75CA615A8C985D4781862AFFAC40'}
      ).that_comes_before([
        'Package[replicated]',
        'Package[replicated-ui]',
        'Package[replicated-updater]'
      ])
    }
    it { is_expected.to contain_apt__source('docker').with(
      :location => 'https://apt.dockerproject.org/repo',
      :key      => {
        "id"     => '58118E89F3A912897C070ADBF76221572C52609D',
        "server" => 'hkp://p80.pool.sks-keyservers.net:80'
        }
      ).that_comes_before('Package[docker-engine]')
    }
    it { is_expected.to contain_apt__pin('nodesource').with(:origin => 'deb.nodesource.com') }
    it { is_expected.to contain_package('apparmor').that_comes_before('Package[docker-engine]') }
    it { is_expected.to contain_package('apt-transport-https') }  # .that_comes_before('Package[docker-engine]') }
    it { is_expected.to contain_package('ca-certificates') }  # .that_comes_before('Package[docker-engine]') }
    it { is_expected.to contain_package('curl').that_comes_before('Package[docker-engine]') }
    it { is_expected.to contain_package('linux-image-extra-3.13.0-61-generic').that_comes_before('Package[docker-engine]') }
    it { is_expected.to contain_package('linux-image-extra-virtual').that_comes_before('Package[docker-engine]') }
    it { is_expected.to contain_package('npmo').that_requires(['Class[nodejs]']) }
    it { is_expected.to contain_package('docker-engine').with(
      :ensure => 'installed',
      )
    }
    it { is_expected.to contain_package('replicated').with(
      :ensure => 'installed',
      ).that_requires( [
        'File[/etc/replicated.conf]',
        'Package[docker-engine]'
      ])
    }
    it { is_expected.to contain_package('replicated-ui').with(
      :ensure => 'installed',
      )
    }
    it { is_expected.to contain_package('replicated-updater').with(
      :ensure => 'installed',
      )
    }
    it { is_expected.to contain_file('/etc/replicated-license-retrieval.json').with_content(/"appid": "66045325f001a1e0ccde2d457cb2b30b",/) }
    it { is_expected.to contain_file('/etc/replicated.conf').with_content(/"LocalAddress": "127.0.0.1"/) }
    it { is_expected.to contain_file('/etc/logrotate.d/replicated').that_requires([
      'Package[replicated]',
      'Package[replicated-ui]',
      'Package[replicated-updater]',
      ])
    }
    it { is_expected.to contain_service('docker').with(:ensure => 'running') }
    it { is_expected.to contain_service('replicated').with(:ensure => 'running') }
    it { is_expected.to contain_service('replicated-ui').with(:ensure => 'running') }
    it { is_expected.to contain_service('replicated-updater').with(:ensure => 'running') }
  end

  describe 'overriding docker_deps' do
    context 'just linux-image-extra' do
      let :params do
        { :docker_deps => ['linux-image-extra-3.13.0-61-generic'] }
      end
      it { is_expected.not_to contain_package('apparmor').that_comes_before('Package[docker-engine]') }
      it { is_expected.not_to contain_package('curl').that_comes_before('Package[docker-engine]') }
      it { is_expected.not_to contain_package('linux-image-extra-virtual').that_comes_before('Package[docker-engine]') }
      it { is_expected.to contain_package('linux-image-extra-3.13.0-61-generic').that_comes_before('Package[docker-engine]') }
    end
    context 'just apparmor' do
      let :params do
        { :docker_deps => ['apparmor'] }
      end
      it { is_expected.to contain_package('apparmor').that_comes_before('Package[docker-engine]') }
      it { is_expected.not_to contain_package('curl').that_comes_before('Package[docker-engine]') }
      it { is_expected.not_to contain_package('linux-image-extra-virtual').that_comes_before('Package[docker-engine]') }
      it { is_expected.not_to contain_package('linux-image-extra-3.13.0-61-generic').that_comes_before('Package[docker-engine]') }
    end
    context 'just curl' do
      let :params do
        { :docker_deps => ['curl'] }
      end
      it { is_expected.not_to contain_package('apparmor').that_comes_before('Package[docker-engine]') }
      it { is_expected.to contain_package('curl').that_comes_before('Package[docker-engine]') }
      it { is_expected.not_to contain_package('linux-image-extra-virtual').that_comes_before('Package[docker-engine]') }
      it { is_expected.not_to contain_package('linux-image-extra-3.13.0-61-generic').that_comes_before('Package[docker-engine]') }
    end
    context 'just curl' do
      let :params do
        { :docker_deps => ['curl'] }
      end
      it { is_expected.not_to contain_package('apparmor').that_comes_before('Package[docker-engine]') }
      it { is_expected.to contain_package('curl').that_comes_before('Package[docker-engine]') }
      it { is_expected.not_to contain_package('linux-image-extra-virtual').that_comes_before('Package[docker-engine]') }
      it { is_expected.not_to contain_package('linux-image-extra-3.13.0-61-generic').that_comes_before('Package[docker-engine]') }
    end
    context 'just linux-image-extra-virtual' do
      let :params do
        { :docker_deps => ['linux-image-extra-virtual'] }
      end
      it { is_expected.not_to contain_package('apparmor').that_comes_before('Package[docker-engine]') }
      it { is_expected.not_to contain_package('curl').that_comes_before('Package[docker-engine]') }
      it { is_expected.to contain_package('linux-image-extra-virtual').that_comes_before('Package[docker-engine]') }
      it { is_expected.not_to contain_package('linux-image-extra-3.13.0-61-generic').that_comes_before('Package[docker-engine]') }
    end
  end

  context 'docker_version of 1.9.2' do
    let :params do
      { :docker_version => '1.9.2' }
    end
    it { is_expected.to contain_package('docker-engine').with(:ensure => '1.9.2') }
  end

  context 'ip_address of 192.168.1.100' do
    let :params do
      { :ip_address => '192.168.1.100' }
    end
    it { is_expected.to contain_file('/etc/replicated.conf').with_content(/"LocalAddress": "192.168.1.100"/) }
  end

  context 'manage_nodejs of false' do
    let :params do
      { :manage_nodejs => false }
    end
    it { is_expected.not_to contain_class('nodejs') }
  end

  context 'manage_nodejs_repo of false' do
    let :params do
      { :manage_nodejs_repo => false }
    end
    it { is_expected.to contain_class('nodejs').with(:manage_package_repo => false) }
  end

  context 'manage_npmo_repo of false' do
    let :params do
      { :manage_npmo_repo => false }
    end
    it { is_expected.not_to contain_apt__source('docker') }
    it { is_expected.not_to contain_apt__source('replicated') }
    it { is_expected.not_to contain_class('npmo::repo::apt') }
  end

  context 'manage_service of false' do
    let :params do
      { :manage_service => false }
    end
    it { is_expected.not_to contain_service('docker') }
    it { is_expected.not_to contain_service('replicated') }
    it { is_expected.not_to contain_service('replicated-ui') }
    it { is_expected.not_to contain_service('replicated-updater') }
  end

  context 'nodejs_version of 4.2.1' do
    let :params do
      { :nodejs_version => '4.2.1' }
    end
    it { is_expected.to contain_class('nodejs').with(:repo_url_suffix => '4.x') }
    it { is_expected.to contain_package('nodejs').with(:ensure => '4.2.1') }
  end

  context 'npm_version of 2.14.14' do
    let :params do
      { :npm_version => '2.14.14' }
    end
    it { is_expected.to contain_package('npm').with(:ensure => '2.14.14') }
  end

  describe 'pin_docker_version of true' do
    context 'docker_version is default' do
      let :params do
        { :pin_docker_version => true }
      end
      it { is_expected.not_to contain_apt__pin('docker-engine') }
    end
    context 'docker_version is 1.9.2' do
      let :params do
        {
          :docker_version => '1.9.2',
          :pin_docker_version => true,
        }
      end
      it { is_expected.to contain_package('docker-engine').with(:ensure => '1.9.2') }
      it { is_expected.to contain_apt__pin('docker-engine').with(:version => '1.9.2') }
    end
  end

  context 'proxy_ip of 192.168.1.10' do
    let :params do
      { :proxy_ip => '192.168.1.10' }
    end
    it { is_expected.to contain_file('/etc/replicated.conf').with_content(/"HttpProxy": "192.168.1.10",/) }
  end

  context 'replicated_version of latest' do
    let :params do
      { :replicated_version => 'latest' }
    end
    it { is_expected.to contain_package('replicated').with(
      :ensure => 'latest',
      ).that_requires( [
        'File[/etc/replicated.conf]',
        'Package[docker-engine]'
      ])
    }
    it { is_expected.to contain_package('replicated-ui').with(
      :ensure => 'latest',
      )
    }
    it { is_expected.to contain_package('replicated-updater').with(
      :ensure => 'latest',
      )
    }
  end

end
