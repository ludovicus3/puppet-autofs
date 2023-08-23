# frozen_string_literal: true

require 'spec_helper'

describe 'autofs::mapping' do
  title = 'testing'
  params = {
    map: '/etc/auto.test',
    location: {
      host: 'localhost',
      path: '/test',
    }
  }

  let(:title) { title }
  let(:params) { params }

  context 'map is immutable' do
    let(:pre_condition) do
      "file { '#{params[:map]}': content => 'this should fail' }"
    end

    it do
      is_expected.to compile
      is_expected.to contain_concat_fragment("#{params[:map]}::#{title}")
    end
  end

  context 'map is mutable' do
    let(:pre_condition) do
      "concat { '#{params[:map]}': }"
    end

    it do
      is_expected.to compile
      is_expected.to contain_concat_fragment("#{params[:map]}::#{title}")
        .with({
                target: params[:map],
              })
    end
  end
end
