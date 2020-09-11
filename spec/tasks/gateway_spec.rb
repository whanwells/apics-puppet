# frozen_string_literal: true

require 'spec_helper'
require_relative '../../tasks/gateway'

describe GatewayTask do
  subject(:task) { described_class.new }

  describe '#task' do
    let(:params) do
      {
        path: '/opt/installer',
        java_home: '/usr/java/default',
        file: 'gateway-props.json',
        action: 'install',
      }
    end

    context 'when path is not absolute' do
      let(:params) { super().merge(path: 'foo') }

      it 'raises an argument error' do
        expect { task.task(params) }.to raise_error('path must be absolute')
      end
    end

    context 'when path is not a directory' do
      before(:each) do
        allow_any_instance_of(Pathname).to receive(:directory?).and_return(false) # rubocop:disable RSpec/AnyInstance
      end

      it 'raises an argument error' do
        expect { task.task(params) }.to raise_error('path must be a directory')
      end
    end

    context 'when path is a directory' do
      let(:env) { { 'JAVA_HOME' => '/usr/java/default' } }
      let(:cmd) { ['/opt/installer/APIGateway', '-f', 'gateway-props.json', '-a', 'install'] }

      before(:each) do
        allow_any_instance_of(Pathname).to receive(:directory?).and_return(true) # rubocop:disable RSpec/AnyInstance
      end

      it 'executes the gateway action' do
        expect(Open3).to receive(:popen2e).with(env, *cmd, chdir: '/opt/installer')

        task.task(params)
      end

      context 'when loglevel is nil' do
        let(:params) { super().merge(loglevel: nil) }

        it 'does not pass a loglevel' do
          expect(Open3).to receive(:popen2e).with(env, *cmd, chdir: '/opt/installer')

          task.task(params)
        end
      end

      context 'with loglevel is not nil' do
        let(:params) { super().merge(loglevel: 'error') }

        it 'passes the upcased loglevel' do
          expect(Open3).to receive(:popen2e).with(env, *cmd, '-l', 'ERROR', chdir: '/opt/installer')

          task.task(params)
        end
      end

      context 'when keyvalue is nil' do
        let(:params) { super().merge(keyvalue: nil) }

        it 'does not pass a keyvalue' do
          expect(Open3).to receive(:popen2e).with(env, *cmd, chdir: '/opt/installer')

          task.task(params)
        end
      end

      context 'when keyvalue is not nil' do
        let(:params) { super().merge(keyvalue: ['foo=bar']) }

        it 'passes the key value pairs' do
          expect(Open3).to receive(:popen2e).with(env, *cmd, '-kv', 'foo=bar', chdir: '/opt/installer')

          task.task(params)
        end
      end
    end
  end
end
