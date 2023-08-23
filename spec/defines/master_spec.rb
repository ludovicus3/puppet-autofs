# frozen_string_literal: true

require 'spec_helper'

describe 'autofs::master' do
  shared_examples 'master entry' do |title, params|
    params = {} if params.nil?

    master = params.fetch(:master, '/etc/auto.master')
    map = params.fetch(:map, title)
    fragment = "#{master}::#{map}"
    content = %r{\+.*}

    it do
      is_expected.to contain_concat__fragment(fragment)
      .with({
        target: master,
        content: content,
      })
    end
  end

  let(:title) { 'namevar' }
  let(:params) do
    {}
  end

  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      it do
        is_expected.to compile
        it_behaves_like 'master entry', title, params
      end
    end
  end
end
