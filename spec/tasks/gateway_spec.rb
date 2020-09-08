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
        allow_any_instance_of(Pathname).to receive(:directory?).and_return(false)
      end

      it 'raises an argument error' do
        expect { task.task(params) }.to raise_error('path must be a directory')
      end
    end

    context 'when path is a directory' do
      let(:env) { { 'JAVA_HOME' => params[:java_home] } }
      let(:cmd) { ['/opt/installer/APIGateway', '-f', params[:file], '-a', params[:action]] }

      before(:each) do
        allow_any_instance_of(Pathname).to receive(:directory?).and_return(true)
      end

      context 'with timeout undefined' do
        it 'executes the action with a 5 minute timeout' do
          expect(task).to receive(:execute).with(env, cmd, params[:path], 300)
          task.task(params)
        end
      end

      context 'with timeout undefined' do
        let(:params) { super().merge(timeout: 1) }

        it 'executes the action with the defined timeout' do
          expect(task).to receive(:execute).with(env, cmd, params[:path], 1)
          task.task(params)
        end
      end

      context 'with loglevel defined' do
        let(:params) { super().merge(loglevel: 'error') }
        let(:cmd) { super() + ['-l', 'ERROR'] }

        it 'upcases the loglevel' do
          expect(task).to receive(:execute).with(env, cmd, params[:path], 300)
          task.task(params)
        end
      end

      context 'with keyvalue defined' do
        let(:params) { super().merge(keyvalue: { foo: 'bar', baz: 'qux' }) }
        let(:cmd) { super() + ['-kv', 'foo=bar', 'baz=qux'] }

        it 'passes the key value pairs' do
          expect(task).to receive(:execute).with(env, cmd, params[:path], 300)
          task.task(params)
        end
      end
    end
  end
end
