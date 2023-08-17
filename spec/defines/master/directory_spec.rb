# frozen_string_literal: true

require 'spec_helper'

describe 'autofs::master::directory' do
  let(:title) { '/etc/auto.master.d' }
  let(:params) do
    {}
  end

  it do
    is_expected.to contain_file('/etc/auto.master.d')
      .with({
              ensure: 'directory',
            })
  end
end
