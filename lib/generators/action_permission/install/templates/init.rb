class ApplicationPermission < ActionPermission::Base

  # Your base permission file
  # You can use this file to set default permissions
  # or overwrite the #load method to manually determine which
  # methods of a permission file are called for each user role

  # example overwrite method
  # def load(user)
  #   @membership = user
  #   send (@membership.role) || "guest"
  # end

  # default permissions

  # def guest
  #   allow [:show]
  # end

  # def user
  #   allow_rest_actions do |user|
  #     @membership.id == user.id
  #   end
  #   allow_params except: [:id]
  # end

  # def admin
  #   allow_rest_actions
  #   allow_params
  # end

end