require 'rubygems'
require 'rails'
require 'rspec'
require './lib/action_permission.rb'

require 'abstract_controller/helpers'
require 'active_record'
require 'nulldb/rails'

ActiveRecord::Base.establish_connection :adapter => :nulldb

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

class TestsController
  include ActionPermission::Controller
  authorize_with :current_user
  def current_user
    Membership.new
  end
  def current_resource
    "current_resource"
  end
  def params
    {controller: "tests", action: "show"}
  end
end

RSpec.configure do |config|
end