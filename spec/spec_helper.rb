require 'rubygems'
require 'rails'
require 'rspec'
require './lib/action_permission.rb'

require 'abstract_controller/helpers'

class Membership
  def identify
    'guest'
  end
end

class TestsPermission < ActionPermission::Base
  def params
    [:name, :email]
  end
  def guest
    allow([:show, :index])
    allow_params
  end
end

class TestController
  include ActionPermission::Controller
  authorize_with :current_user
  def current_user
    Membership.new
  end
  def current_resource
    "current_resource"
  end
end

RSpec.configure do |config|
end