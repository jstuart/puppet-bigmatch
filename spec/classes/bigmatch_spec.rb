require 'spec_helper'

describe 'bigmatch' do
  context "operatingsystem => #{default_facts[:operatingsystem]}" do

    context 'operatingsystemmajrelease => 6' do
      let :facts do
        default_facts.merge({
          :operatingsystemrelease     => '6.4',
          :operatingsystemmajrelease  => '6',
        })
      end

    it { should create_class('bigmatch') }

    end

  end
end