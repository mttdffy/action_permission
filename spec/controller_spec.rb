require 'spec_helper'

describe ActionPermission::Controller do

  before do
    class BadController
      include ActionPermission::Controller
      authorize_with :current_user
      def current_user
        "current_user"
      end
    end
  end

  let (:controller) { TestsController.new }
  let (:bad_controller) { BadController.new }

  describe 'included' do
    it "should add delegate methods" do
      TestsController.instance_methods.should include(:allow?)
      TestsController.instance_methods.should include(:allow_param?)
      TestsController.instance_methods.should include(:allowed_params_for)
    end

    it "should add helper methods" do
      TestsController._helper_methods.should include(:allow?)
      TestsController._helper_methods.should include(:allow_param?)
      TestsController._helper_methods.should include(:current_permission)
    end
  end

  describe '.authorize_with' do
    before do
      class SomeController
        include ActionPermission::Controller
        authorize_with :dub_dub
        def dub_dub; end
      end
    end

    it 'should set permission_authorizer' do
      SomeController.permission_authorizer.should eq(:dub_dub)
    end

    it 'should add method to helper methods' do
      SomeController._helper_methods.should include(:dub_dub)
    end
  end

  describe ".permission_authorizer" do

    it "should respond as the method define with authorize_with" do
      TestsController.permission_authorizer.should eq(:current_user)
    end
  end

  describe "#current_permission" do
    it "should respond with an instance of ActionPermission::Dispatch" do
      controller.current_permission.is_a?(ActionPermission::Dispatch).should be_true
    end

  end

  describe "#current_resource" do
    it "should respond nil if inherited class has no current_resource method" do
      bad_controller.current_resource.should be_nil
    end

    it "should respond with controller instance method if one is defined" do
      controller.current_resource.should eq("current_resource")
    end

  end

  describe '#authorize?' do
    it 'should pass the current controller and action into dispatch' do
      dispatch = double
      allow(dispatch).to receive(:allow?).and_return(true)

      controller.should_receive(:current_permission).
        and_return(dispatch)

      dispatch.should_receive(:allow?).
        with("tests", "show", "current_resource")

      controller.authorized?
    end

    it "should return true if action is allowed" do
      controller.authorized?
    end

    it "should return false if action is not allowed" do
      controller.should_receive(:params).and_return({controller: "tests", action: "new"})
      controller.should_receive(:params).and_return({controller: "tests", action: "new"})

      controller.authorized?
    end
  end

end