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

  let (:controller) { TestController.new }
  let (:bad_controller) { BadController.new }

  describe '.authorize_with' do

  end

  describe ".permission_authorizer" do

    it "should respond as the method define with authorize_with" do
      TestController.permission_authorizer.should eq(:current_user)
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

  end

end