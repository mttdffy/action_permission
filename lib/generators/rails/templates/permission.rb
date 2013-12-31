<% module_namespacing do -%>
class <%= controller_class_name %>Permission < ApplicationPermission

  def params
    [<%= attributes.map {|a| ":#{a.name}" }.sort.join(', ') %>]
  end

  # define methods for each of your user roles here
  # allow [:actions] defines routes allowed for that rold
  # an optional block can be passed to allow to check 
  # things like ownership.

  # @membership is available as the object returned from
  # method passed to ActionPermission::Controller#authorize_with
  
  def guest
    allow [:show]
  end

  def user
    allow_rest_actions do |user|
      @membership.id == user.id
    end
    allow_params except: [:id]
  end

  def admin
    allow_rest_actions
    allow_params
  end

end
<% end -%>