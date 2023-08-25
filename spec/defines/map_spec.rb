# frozen_string_literal: true

require 'spec_helper'

describe 'autofs::map' do
  shared_examples 'entry' do |title, params|
    params = {} if params.nil?

    master = params.fetch(:master, '/etc/auto.master')
    fragment = "#{master}::#{params.fetch(:map, title)}"
    fragment_params = {
      target: master,
      content: %r{\S+[ \t]+(\S+(,\S+)?:)?\S+([ \t]+\S+)?},
    }

    it do
      is_expected.to contain_concat__fragment(fragment).with(fragment_params)
    end
  end

  title = '/etc/auto.test'
  params = {
    mount: '/test',
  }

  context 'type is dir' do
    let(:title) { title }
    let(:params) { params.merge!({ type: 'dir' }) }

    it do
      is_expected.to compile.and_raise_error(%r{.*})
    end
  end

  [nil, 'file', 'program', 'exec'].each do |type|
    context "type is #{type || 'undef'}" do
      local = params.merge({ type: type }).compact

      let(:title) { title }
      let(:params) { local }

      it_behaves_like 'entry', title, local
      it do
        is_expected.to contain_file(local.fetch(:map, title)).with(local.slice(:owner, :group, :mode, :content, :source))
      end
    end
  end

  ['yp', 'nisplus', 'hesiod', 'ldap', 'ldaps'].each do |type|
    context "type is #{type}" do
      let(:title) { title }
      let(:params) { params.merge!({ type: type }) }

      it do
        is_expected.to compile
      end
      it_behaves_like 'entry', title, params
    end
  end
end
