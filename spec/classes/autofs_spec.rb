# frozen_string_literal: true

require 'spec_helper'

describe 'autofs' do
  let(:params) do
    {
      maps: {
        '/etc/auto.home': {
          mount: '/home',
          mappings: {
            'test': {
              location: {
                path: '/test',
              }
            }
          }
        }
      }
    }
  end

  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      it do
        is_expected.to compile

        is_expected.to contain_class('Autofs::Install')
        is_expected.to contain_class('Autofs::Config')
        is_expected.to contain_class('Autofs::Service')

        is_expected.to contain_package('autofs')
          .with({
                  ensure: 'installed',
                })

        is_expected.to contain_ini_setting('autofs::timeout')
        is_expected.to contain_file('/etc/autofs_ldap_auth.conf')
        is_expected.to contain_concat('/etc/auto.master')

        is_expected.to contain_service('autofs')
          .with({
                  ensure: 'running',
                  enable: true,
                }).that_subscribes_to('Concat[/etc/auto.master]')
      end
    end
  end
end
