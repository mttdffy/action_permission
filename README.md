# ActionPermission

[![Gem Version](https://badge.fury.io/rb/action_permission.png)](http://badge.fury.io/rb/action_permission)
[![Code Climate](https://codeclimate.com/github/mttdffy/action_permission.png)](https://codeclimate.com/github/mttdffy/action_permission)

A permission structure for defining both action-based and attribute-based permissions for rails 4+ applications. 

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'action_permission'
```

And then execute:

```sh
$ bundle
$ rails generate action_permission:install
```

## Usage

ActionPermission assumes you have the concept of user roles/levels/segments. This can be any field on any object. It's core action is to load permissions that correspond to the controller handling the current request, determine the user's access level, and call a method on the permission object that corresponds to that level. A permission file might look like this:

```ruby
class BooksPermission < ApplicationPermission

  def params
    [:name, :author, :isbn, :page_count, :price]
  end

  def guest
    allow [:index, :show]
  end
  
  match_with :guest, :member

  def editor
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

- the `params` method can be used to define attributes allowed to be modified by that user level in addition to their allowed actions, which can be further refined for each level using `except` and `only options`.
- the `@membership` attribute is set on initialization of the permission object. See setup for details in 'Setup'


## Setup

```sh
$ rails generate action_permission:install
```

This generator creates the `app/permissions` directory along with a `application_perimission.rb` file.

Permissions should be placed in the `app/permissions` directory and mimic the structure of your controllers. Each permission will typically extend from `ApplicationPermission`, allowing you to set default permissions for each role. 

Additionally, the install generator will add some boilerplate code into your `ApplicationController` required for setting up ActionPermission. It will look much like this:

```ruby
#app/controllers/application_controller.rb

authorize_with :current_user
before_action :check_permission

def current_user
  @current_user ||= session[:user_id] ? User.find(session[:user_id]) : User.new
end

def check_permission
  unless authorized?
    #do something when user does not have permission to access page
    # Flash[:warn] = "You do not have permission to access this page."
    # redirect_to root_url
  end
end

```

This is a basic implementation that you can change and modify to work with your application's user role structure.

Ultimately, ActionPermission looks to receive a string representing the name of the role/level of current user. It requires you to pass a method to `authorize_with` in your `ApplicationController` to call when loading permissions. 

- This method should return an object that can repond to an `#identify` method. 
- Object returned is set as `@membership` for use in `#allow` blocks (see example permission class above) 
- `#identify` is expected to return a string or symbol representing the user's role/level. A method with a name matching this return value will be called on the permission object.

```ruby
# app/models/user.rb
class User < ActiveRecord::Base

  # assume User#role exists as a string representation
  # of what role that user is

  def identify
    role || "guest"
  end
end

```

Alternatively, you can overwrite `ActionPermission::Base#load` in the `ApplicationPermission` class to define your own way of determining a method to call.

```ruby
class ApplicationPermission < ActionPermission::Base
  
  def load(user)
    @membership = user
    send @membership.access_level
  end

end

```

Once you have it setup, your controller has access to an `authorized?` method which will tell you if the current user has permission to access the current action

```ruby
# app/controllers/application_controller.rb
ApplicationController < ActionController::Base
  
  before_action :check_permissions

  def check_permissions
    unless authorized?
      flash[:warn] = "You do not have permission to access this page"
      rediect_to root_url
    end
  end 
end
```

You can set this at a global level in `ApplicationController`, or be specific about how it handles unauthorized access by checking `#authorized?` in an individual controller. Or both. 

## Parameters

You can enforce the user level's parameter access by using the `#allowed_params_for` method in each controller to retrieve the parameters to be passed into create or update methods.

```ruby
class BooksController < ApplicationController

  # ...
  def create
    @book = Book.new(book_params)
    if @book.save
      redirect_to @book
    else
      render :new
    end
  end
  
  private
  
  def book_params
    allowed_params_for :book, params 
  end
  
  # ...

end

```

The example above will load the `BooksPermission` class, call the method corresponding to the user's level, then filter the parameters in `params[:book]` based on the permission instance and return the allowed parameters. This uses and hooks into strong_parameters. 

### `allowed_params_for(resource, params [, controller])`

`#allowed_params_for` requires two arguments, and takes an options third. 

Both `resource` and `controller` can be a string, symbol, Class, or Class instance. 

By default, resource will be used to guess which permission to load, but you can explicity tell it which controller (thus corresponding permission file), you intend to check.  This comes into play when controllers and models are namespaced and may not be namespaced in the same way. 

```ruby

# would load BooksPermission 
# and filter :book key of params
allowed_params_for @book, params

# would load Libraries::BooksPermission 
# and filter :library_book key of params
allowed_params_for 'library/book', params

# would load permission corresponding to current controller
# and filter :book key from params
allowed_params_for :book, params, self

# would load Admin::BooksPermission 
# and filter :user_book key of params
allowed_params_for 'user/book', params, Admin::BooksController

# would load Library::BooksPermission 
# and filter :user_book key of params
allowed_params_for User::Book, params, 'library/books'
```

## Generators

    rails g action_permission:install
    
This will add the base application_permission.rb file as well as add some boilerplate code to the application controller

    rails g action_permission:permission CONTROLLER [attribute, attribute, ...]
    
    rails g action_permission:permission users username name email role password_digest
    
This will generate a permission file for the supplied controller. YOu can pass in attributes to auto populate the params method for that permission object. In the future this will be added onto the scaffolding generator so you don't have to run this seperately

## Contributors

- [Matt Duffy](https://github.com/mttdffy)
- [Brian McElaney](https://github.com/mcelaney)
- [Mark Platt](https://github.com/mrkplt)

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
