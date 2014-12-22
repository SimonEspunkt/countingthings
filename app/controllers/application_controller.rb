class ApplicationController < ActionController::Base
 	include Pundit
	rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  protected    

    def authenticate_user!
      if user_signed_in?
        super
      else
        flash[:alert] = "Du bist noch nicht angemeldet! Bitte logge dich unten ein!"
        redirect_to root_path
      end
    end

  	def after_sign_in_path_for(resource)
  		things_path
  	end

    def after_sign_out_path_for(resource)
      root_path
    end

    def user_not_authorized
      flash[:alert] = "You are not authorized to perform this action."
      redirect_to(request.referrer || things_path)
    end

end
