# frozen_string_literal: true

require 'spec_helper'

describe 'autofs::master' do
  shared_examples 'master entry' do |title, params|
    params = {} if params.nil?

    master = params.fetch(:master, '/etc/auto.master')
    map = params.fetch(:map, title)
    fragment = "#{master}::#{map}"
    content = %r{\+(\S+(,\S+)?:)?\S+([ \t]+\S+)?}

    it do
      is_expected.to compile
      is_expected.to contain_concat__fragment(fragment)
      .with({
        target: master,
        content: content,
      })
    end
  end

  shared_examples 'master directory' do |title, params|
    params ||= {}

    let(:title) { title }
    let(:params) { params }

    it_behaves_like 'master entry', title, params
    it do
      is_expected.to contain_autofs__master__directory(params.fetch(:map, title))
      .with(params.slice(:owner, :group, :mode, :purge))
    end
  end

  shared_examples 'master file' do |title, params|
    params ||= {}

    let(:title) { title }
    let(:params) { params }

    it_behaves_like 'master entry', title, params
    it do
      is_expected.to contain_autofs__master__file(params.fetch(:map, title))
      .with(params.slice(:owner, :group, :mode, :maps, :content, :source))
    end
  end

  title = '/etc/test.autofs'
  
  it_behaves_like 'master directory', title, { type: 'dir' }
  it_behaves_like 'master file', title, {}
  it_behaves_like 'master file', title, { type: 'file' }

  context 'type is program' do
    let(:title) { title }
    let(:params) { { type: 'program' } }

    it do
      is_expected.to compile.and_raise_error(/.*/)
    end
  end

  context 'type is exec' do
    let(:title) { title }
    let(:params) { { type: 'exec' } }

    it do
      is_expected.to compile.and_raise_error(/.*/)
    end
  end

  ['yp', 'nisplus', 'hesiod', 'ldap', 'ldaps'].each do |type|
    context "type is #{type}" do
      let(:title) { title }
      let(:params) { {type: type}}
      
      it_behaves_like 'master entry', title, { type: type }
    end
  end
end
