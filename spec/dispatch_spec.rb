require 'spec_helper'

describe ActionPermission::Dispatch do

  let(:membership) { Membership.new }
  let(:dispatch) { ActionPermission::Dispatch.new(membership) }

  describe '#allow?' do
    it 'should load the appropriate permission file' do
      dispatch.should_receive(:load_permission).
        with(:test).
        and_return(TestsPermission.new(membership))

      dispatch.allow?(:test, :index)
    end

    it 'should return true for allowed actions' do
      dispatch.allow?(:test, :index).should be_true
    end

    it 'should return false for actions now allowed' do
      dispatch.allow?(:test, :new)
    end
  end

  describe '#allowed_params_for' do

    before do
      class Test < ActiveRecord::Base; end
    end

    let(:params) do
      p = double
      allow(p).to receive(:require).and_return(p)
      allow(p).to receive(:permit)
      p
    end

    describe 'top level resources and controllers' do

      before(:each) do
        permission = double("TestsPermission", allowed_params: [:name, :email])
        dispatch.should_receive(:load_permission)
          .with("tests")
          .and_return(permission)

        params.should_receive(:permit)
          .with(*permission.allowed_params)
      end

      let(:test_instance) do
        test = double
        allow(test).to receive(:class).and_return(Test)
        test
      end

      context 'resource formatting' do
        it "loads permission when provided a symbol" do
          params.should_receive(:require).with("test")
          dispatch.allowed_params_for(:test, params)
        end
        it 'loads permission when provided a string' do
          params.should_receive(:require).with("test")
          dispatch.allowed_params_for('test', params)
        end
        it 'loads permission when provided class' do
          params.should_receive(:require).with("test")
          dispatch.allowed_params_for(Test, params)
        end
        it 'loads permission when provided class instance' do
          Test.should_receive(:new).and_return(test_instance)
          params.should_receive(:require).with("test")
          dispatch.allowed_params_for(Test.new, params)
        end
      end

      context 'controller formatting' do
        it 'loads permssion when provided a controller string' do
          dispatch.allowed_params_for 'test', params, 'test'
        end
        it 'loads permssion when provided a controller symbol' do
          dispatch.allowed_params_for 'test', params, :test
        end
        it 'loads permssion when provided a controller class' do
          dispatch.allowed_params_for 'test', params, TestsController
        end
        it 'loads permssion when provided a controller string' do
          dispatch.allowed_params_for 'test', params, TestsController.new
        end
      end
    end

    describe 'nested resources' do
      before do
        module Suite
          class Test < ActiveRecord::Base; end
        end
        module Suites
          class TestsController; end
        end
      end

      before(:each) do
        permission = double("TestsPermission", allowed_params: [:name, :email])
        dispatch.should_receive(:load_permission)
          .with("suites/tests")
          .and_return(permission)
      end

      let(:test_instance) do
        test = double
        allow(test).to receive(:class).and_return(Suite::Test)
        test
      end

      context 'resource formatting' do
        it 'loads permission when provided a string' do
          params.should_receive(:require).with("suite_test")
          dispatch.allowed_params_for('suite/test', params)
        end
        it 'loads permission when provided class' do
          params.should_receive(:require).with("suite_test")
          dispatch.allowed_params_for(Suite::Test, params)
        end
        it 'loads permission when provided class instance' do
          Suite::Test.should_receive(:new).and_return(test_instance)
          params.should_receive(:require).with("suite_test")
          dispatch.allowed_params_for(Suite::Test.new, params)
        end
      end

      context 'controller formatting' do
        it 'loads permssion when provided a controller string' do
          dispatch.allowed_params_for 'test', params, 'suites/tests'
        end
        it 'loads permssion when provided a controller class' do
          dispatch.allowed_params_for 'test', params, Suites::TestsController
        end
        it 'loads permssion when provided a controller string' do
          dispatch.allowed_params_for 'test', params, Suites::TestsController.new
        end
      end
    end
  end

  describe '#allow_param?' do
    it 'should load the appropriate permission file' do
      dispatch.should_receive(:load_permission).
        with("tests").
        and_return(TestsPermission.new(membership))

      dispatch.allow_param?(:test, :index)
    end

    it 'should return true for allowed params' do
      dispatch.allow_param?(:test, :name).should be_true
    end

    it 'should return false for actions now allowed' do
      dispatch.allow_param?(:test, :password)
    end
  end

end