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

end
