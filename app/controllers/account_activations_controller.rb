class AccountActivationsController < ApplicationController
  def edit
    user = Usuario.find_by(email: params[:email])
    
    if user && !user.activated? && user.authenticated?(:activation, params[:id])
      user.activate
      log_in user
      flash[:success] = t :msg_info_conta_ativada
      redirect_to user
    else
      flash[:danger] = t :msg_erro_link_ativacao_invalido
      redirect_to root_url
    end
  end
end
