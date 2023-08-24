# frozen_string_literal: true

require 'spec_helper'

describe 'autofs::mapping' do
  shared_examples 'mapping' do |title, params|
    params = {} if params.nil?

    key = params.fetch(:key, title)
    map = params.fetch(:map)

    fragment = "#{map}::#{key}"

    content = %r{\S+[ \t]+(-\S+[ \t]+)?(\S*:\S+)|((\S+[ \t]+(-\S+[ \t]+)?\S*:\S+[ \t]*\\\n[ \t]*)*(\S+[ \t]+(-\S+[ \t]+)?\S*:\S+))}

    let(:title) { title }
    let(:params) { params }
    it do
      is_expected.to compile
      is_expected.to contain_concat__fragment(fragment)
      .with({
        target: map,
        content: content,
      })
    end
  end

  title = 'testing'
  params = {
    map: '/etc/auto.test',
  }

  context 'location is :/path' do
    location = {
      path: '/path',
    }
    
    it_behaves_like 'mapping', title, params.merge({
      options: 'test,test=1',
      location: location,
    })
    it_behaves_like 'mapping', title, params.merge({
      options: ['test', 'test=1'],
      location: location,
    })
    it_behaves_like 'mapping', title, params.merge({location: location})
  end

  context 'location is host:/path' do
    location = {
      host: 'host',
      path: '/path',
    }

    it_behaves_like 'mapping', title, params.merge({
      options: 'test,test=1',
      location: location,
    })
    it_behaves_like 'mapping', title, params.merge({
      options: ['test', 'test=1'],
      location: location,
    })
    it_behaves_like 'mapping', title, params.merge({location: location})
  end

  context 'location is /mount host:/path' do
    location = {
      '/' => {
        host: 'host',
        path: '/path_a',
      },
      '/b' => {
        path: '/path_b',
      },
      '/c' => {
        options: 'test,test=1',
        path: '/path_c',
      },
      '/d' => {
        host: 'host',
        options: 'test,test=1',
        path: '/path_d',
      },
      '/e' => {
        options: ['test', 'test=1'],
        path: '/path_e',
      },
      '/f' => {
        host: 'host',
        options: ['test', 'test=1'],
        path: '/path_f',
      }
    }
    it_behaves_like 'mapping', title, params.merge({location: location})
  end
end
