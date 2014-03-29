class Users::RegistrationsController < Devise::RegistrationsController
    # This controller overrides devise things for things that need customization
    before_filter :check_permissions, :only => [:new, :create, :cancel]
    skip_before_filter :require_no_authentication

    def check_permissions
        authorize! :create, resource
    end

end
