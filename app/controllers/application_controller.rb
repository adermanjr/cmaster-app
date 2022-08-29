class ApplicationController < ActionController::Base
    protect_from_forgery with: :exception
    include SessionsHelper
    
    before_action :set_locale
    
    around_action :set_fuso, if: :current_user
  
    def set_locale
      locale = params[:locale] || cookies[:locale]
      if locale.present?
        I18n.locale = locale
        cookies[:locale] = { value: locale, expires: 30.days.from_now}
      end
    end
    
    private
      # Confirms a logged-in user.
      def logged_in_user
        unless logged_in?
          store_location
          flash[:danger] = t :msg_erro_desconectado
          redirect_to login_url
        end
      end
      
      def set_fuso
        Time.use_zone(current_user.fuso) { yield }
      end
end
