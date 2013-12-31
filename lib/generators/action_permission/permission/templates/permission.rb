<% module_namespacing do -%>
class <%= controller_class_name %>Permission < ApplicationPermission

  # defines parameters for requests coming to associated object/controlelr
  # typically defines all attributes and uses except option to exclude
  # params on a per-role basis
  def params
    [<%= attributes.map {|a| ":#{a.name}" }.sort.join(', ') %>]
  end

  # define methods for each of your user roles here

  # allow [:actions] 
  # defines routes allowed for that role
  # an optional block can be passed to allow to check 
  # things like ownership.

  # allow_params
  # options: [:except, :only]
  # define params user role can change
  # no options gives access to all of #params
  # except excludes any listed
  # only overwrites params array

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