require 'spec_helper'
describe 'npmo' do

  let :facts do {
    :lsbdistcodename => 'trusty',
    :lsbdistid       => 'Ubuntu',
    :operatingsystem => 'Ubuntu',
    :osfamily        => 'Debian',
    }
  end


  context 'with defaults for all parameters' do
    it { should contain_class('npmo') }
    it { should contain_class('npmo::params') }
    it { should contain_class('npmo::repo') }
    it { should contain_class('npmo::repo::apt') }
    it { should contain_apt__source('replicated').with(
      :location => 'https://get.replicated.com/apt',
      :key => { "id" => '68386EDB2C8B75CA615A8C985D4781862AFFAC40'}
      )
    }
    it { should contain_apt__source('docker').with(
      :location => 'https://apt.dockerproject.org/repo',
      :key      => {
        "id"     => '58118E89F3A912897C070ADBF76221572C52609D',
        "server" => 'hkp://p80.pool.sks-keyservers.net:80'
        }
      )
    }
  end
end
