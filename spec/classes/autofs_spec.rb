# frozen_string_literal: true

require 'spec_helper'

describe 'autofs' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      it do
        is_expected.to compile

        is_expected.to contain_package('autofs').with({
                                                        ensure: 'installed',
                                                      })

        is_expected.to contain_service('autofs').with({
                                                        ensure: 'running',
          enable: true,
                                                      })
      end
    end
  end
end
