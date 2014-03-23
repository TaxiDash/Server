class Users::RegistrationsController < Devise::RegistrationsController
    # This controller overrides devise things for things that need customization
    before_filter :check_permissions, :only => [:new, :create, :cancel]
    skip_before_filter :require_no_authentication

    def check_permissions
        authorize! :create, resource
    end

    def edit
        puts @current_user.id.to_s << " (" << @current_user.username << ")"<< " is editing " << @user.id.to_s << " (" << @user.username << ")"
        if @current_user.id == @user or can? :update, User then
            super
        end
    end
end
