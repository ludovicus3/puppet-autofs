# frozen_string_literal: true

require 'spec_helper'

describe 'autofs::master::file' do
  title = '/etc/test.autofs'
  params = {
    owner: 'test',
    group: 'test',
    mode: '0640',
  }

  let(:title) { title }

  context 'nothing defined' do
    let(:params) { params }

    it do
      is_expected.to compile
      is_expected.to contain_file(title)
        .with({
                ensure: 'file',
              })
    end
  end

  context 'maps defined' do
    test_map_title = '/etc/auto.test'
    test_map = {
      mount: '/test',
    }

    let(:params) do
      params.merge({
                     maps: {
                       test_map_title => test_map,
                     }
                   })
    end

    it do
      is_expected.to compile
      is_expected.to contain_concat(title)
      is_expected.to contain_autofs__map(test_map_title).with(test_map.merge({ master: title }))
    end
  end

  context 'content defined' do
    content = 'testing'

    let(:params) do
      params.merge({
                     content: content,
                   })
    end

    it do
      is_expected.to compile
      is_expected.to contain_file(title)
        .with({
                content: content,
              })
    end
  end

  context 'source defined' do
    source = 'https://test.com/testing'

    let(:params) do
      params.merge({
                     source: source,
                   })
    end

    it do
      is_expected.to compile
      # is_expected.to contain_file(title)
      #  .with({
      #          source: source,
      #        })
    end
  end
end
