# ActionPermission

A permission structure for defining both action-based and attribute-based permissions for rails 3+ applications. 

## Installation

Add this line to your application's Gemfile:

    gem 'action_permission'

And then execute:

    $ bundle
    $ rails generate action_permission:init

## Usage

ActionPermission assumes you have the concept of user roles. This can be any field of any name. It's core action to load permissions for the controller handling the request, determine the user's access level, and call a method on the permission object that corresponds to that level. A permission file might look like this:

```ruby
class BookPermission < ApplicationPermission

  def params
    [:name, :author, :isbn, :page_count, :price]
  end

  def guest
    allow [:index, :show]
  end

  def user
    allow [:index, :show, :new]
    allow [:create, :edit, :update, :destroy] do |user|
      @membership.id == user.id
    end
    allow_params except: [:price]
  end

  def admin
    allow_rest_actions
    allow_params
  end

end
```

- the `params` method can be used to define attributes allowed to be modified by that user level in addition to their allowed actions.
- the `@membership` attribute is set on initialization based on the method handed to `authorize_with` in your `ApplicationController` (See 'Setup' below)


## Setup

Permissions should be placed in the `app/permissions` directory. Each permission will typically extend from `ApplicationPermission`, allow you to set default permissions for each role. 

Ultimately, ActionPermission looks to receive a string representing the name of the role/level of current user. It requires you to define a method on your `ApplicationController` to call when loading permissions. This method should return an object that can repond to a `#identify` method. `identify` method should return a string value of the current user's role

```ruby
# app/controllers/application_controller.rb
ApplicationController < ActionController::Base
  
  ...

  authorize_with :current_user

  def current_user
    @current_user ||= session[:user_id] ? User.find(session[:user_id]) : User.new
  end

  ...
end

# app/models/user.rb
class User < ActiveRecord::Base

  # assume User#role exists as a string representation
  # of what role that user is

  def identify
    role || "guest"
  end
end

```

Alternatively, you can overwrite `ActionPermission::Base#initialize` in the `ApplicationPermission` class to define your own way of determining a method to call.

```ruby


```

TODO: Write usage instructions here

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
