require 'spec_helper'

describe ActionPermission::Base do

  let(:membership) { Membership.new }
  let(:base_permission) { ActionPermission::Base.new(membership)}
  let(:test_permission) { TestsPermission.new(membership) }

  describe '#load' do
    it 'should call #identify on object passed as membership' do
      membership.should_receive(:identify)
      base_permission
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
      base_permission.allow([:show]){ 'test' }
      base_permission.allow?(:show).should be_false
    end

    context "with a provided resource" do
      it 'should return true if keys value is a proc that returns truthy' do
        base_permission.allow([:show]){ |resource|  resource }
        base_permission.allow?(:show, true).should be_true
      end

      it 'should return false if keys value is a proc that returns falsey' do
        base_permission.allow([:show]){ |resource|  false }
        base_permission.allow?(:show, true).should be_false
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
    it "should add all 7 basic rest actions to allowed_actions" do
      base_permission.allow_rest_actions
      base_permission.allowed_actions.keys.size.should eq(7)
      base_permission.allowed_actions.keys.should eq(['index', 'new', 'create', 'show', 'edit', 'update', 'destroy'])
    end
  end

  describe '#params' do
    it "should return array of all params allowed by permission" do
      test_permission.params.should eq([:name, :email])
    end
  end

  describe '#allow_params' do
    it "should set the allowed_params for the permission object" do
      test_permission.should_receive(:params).and_return([:name,:email])
      test_permission.allow_params
      test_permission.allowed_params.should eq([:name, :email])
    end

    it "should call allow_params_with_options to handle options" do
      test_permission.should_receive(:allow_params_with_options)
      test_permission.allow_params(except: :email)
    end

    it 'should exclude params from array based on except option' do
      test_permission.allow_params(except: :email)
      test_permission.allowed_params.should_not include(:email)
    end

    it 'should include only params pasted from the only option' do
      test_permission.allow_params(only: :name)
      test_permission.allowed_params.should_not include(:email)
    end
  end

end