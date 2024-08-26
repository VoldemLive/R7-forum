class ApplicationController < ActionController::Base
    before_action :set_current_user
  
  private
    def set_current_user
      if session[:current_user]
        begin
          @current_user = User.find(session[:current_user])
        rescue
          session[:current_user] = nil
          @current_user = nil
          redirect_to users_path, notice: "You have logged off."
        end
      else
        @current_user = nil
      end
    end
end