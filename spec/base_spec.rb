require 'spec_helper'

describe ActionPermission::Base do

  before do
    class Membership
      def identify
        'guest'
      end
    end

    class TestPermission < ActionPermission::Base
      def guest
        allow[:show, :index]
      end
    end
  end

  let(:membership) { Membership.new }
  let(:base_permission) { ActionPermission.new(membership)}
  let(:test_permission) { TestPermission.new(membership) }

  describe '#load' do
    it 'should call #identify on object passed as membership' do
      membership.should_receive(:identify)
      ActionPermission::Base.new(membership)
    end

    it 'should call a method on the permission equal to the value returned by membership#idenify' do
      test_permission.should_receive(:guest)
      test_permission.load(membership)
    end

    it 'should set membership on the permission instance' do
      test_permission.membership.is_a?(Membership).should be_true
    end
  end

  describe '#allow?' do
    it 'should return the value of the key passed' do
      base_permission.allow([:show])
      base_permission.allow?(:show).should be_true
    end

    it 'should return false if passed value that is not a key' do
      base_permission.allow([:show])
      base_permission.allow?(:index).should be_false
    end

    it 'should return false if keys value is a proc but no resource exists' do
      base_permission.allow [:show] { 'test' }
      base_permission.allow?(:show).should be_false
    end

    context "with a provided resource" do
      it 'should return true if keys value is a proc that returns truthy' do
        base_permission.allow [:show], true { |resource|  resource }
        base_permission.allow?(:show).should be_true
      end

      it 'should return false if keys value is a proc that returns falsey' do
        base_permission.allow [:show], true { |resource|  false }
        base_permission.allow?(:show).should be_false
      end
    end
  end

  describe '#allow' do
    it 'should add actions passed to instance allow_actions hash keys' do
      base_permission.allow([:show])
      base_permission.allowed_actions.keys.include?('show').should be_true
    end

    it 'should set value of action keys to true if no block was passed' do
      base_permission.allow([:show])
      base_permission.allowed_actions['show'].should be_true
    end

    it 'should set a block as the value of the action keys when a block was given' do
      base_permission.allow [:show] { 'test' }
      base_permission.allowed_actions['show'].call.should eq('test')
    end
  end

  describe '#allow_rest_actions' do

  end

  describe '#params' do

  end

  describe '#allow_params' do

  end

  describe '#allow_params_with_options' do

  end

end