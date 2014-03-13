require 'spec_helper'

describe ActionPermission::Controller do

  before do

    class TestController
      include ActionPermission::Controller
      authorize_with :current_user
      def current_user
        "current_user"
      end
    end

  end

  let (:controller) { TestController.new }

  describe ".permission_authorizor" do

    it "should respond as the method define with authorize_with" do
      TestController.permission_authorizor.should eq(TestController.new.current_user)
    end
  end

  describe "#current_permssion" do
    it "should respond with an instance of ActionPermission::Dispatch" do
      controller.current_permssion.is_a?(ActionPermission::Dispatch).should be_true
    end

  end

  describe "#current_resource" do
    it "should respond with controller instance method if one is defined" do
      class TestController
        def current_resource
          "current_resource"
        end
      end

      controller.current_resource.should eq("current_resource")
    end

    it "should respond nil if inherited class has no current_resource method" do
      controller.current_resource.should be_nil
    end
  end

end