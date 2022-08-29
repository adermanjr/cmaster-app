class PasswordResetsController < ApplicationController
  before_action :get_user,   only: [:edit, :update]
  before_action :valid_user, only: [:edit, :update]
  before_action :check_expiration, only: [:edit, :update]
  
  def new
  end

  def create
    @usuario = Usuario.find_by(email: params[:password_reset][:email].downcase)
    if @usuario
      @usuario.create_reset_digest
      @usuario.send_password_reset_email
      flash[:info] = t :msg_info_verifique_email_resetar_senha
      redirect_to root_url
    else
      flash.now[:danger] = t :msg_erro_email_nao_encontrado
      render 'new'
    end
  end

  def edit
  end
  
  def update
    if params[:usuario][:password].empty?                  # Case (3)
      @usuario.errors.add(:password, t(:msg_erro_complemento_nao_esta_preenchido))
      render 'edit'
    elsif @usuario.update(user_params)          # Case (4)
      log_in @usuario
      @usuario.update_attribute(:reset_digest, nil)
      @usuario.activate if (!@usuario.activated?)
      flash[:success] = t :msg_info_senha_atualizada
      redirect_to @usuario
    else
      render 'edit'                                     # Case (2)
    end
  end
  
  private
    
    def user_params
      params.require(:usuario).permit(:password, :password_confirmation)
    end

    # Before filters
    def get_user
      @usuario = Usuario.find_by(email: params[:email])
    end

    # Confirms a valid user.
    def valid_user
      unless (@usuario && @usuario.activated? &&
              @usuario.authenticated?(:reset, params[:id]))
        redirect_to root_url
      end
    end
    
    # Checks expiration of reset token.
    def check_expiration
      if @usuario.password_reset_expired?
        flash[:danger] = t :msg_erro_link_expirou
        redirect_to new_password_reset_url
      end
    end
end
