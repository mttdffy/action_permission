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