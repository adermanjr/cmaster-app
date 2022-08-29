class SessionsController < ApplicationController

  def new
  end

  def create
    @usuario = Usuario.find_by(email: params[:session][:email].downcase)
    if @usuario && @usuario.authenticate(params[:session][:password])
      
      if @usuario.activated?
        log_in @usuario
        params[:session][:remember_me] == '1' ? remember(@usuario) : forget(@usuario)
        
        if @usuario.planos.count == 0
          #request.path %>?locale=pt-BR"
          redirect_to editar_assinatura_usuario_path(@usuario) + "?locale=#{@usuario.lingua}"
        else
          if !bloquear?(@usuario)
            redirect_back_or @usuario
          else
            redirect_to detalhar_assinatura_usuario_path(@usuario)
          end
        end
      else
        if @usuario.passo_criacao == PASSO_ENDERECO
          redirect_to endereco_usuario_path(@usuario)
        elsif @usuario.passo_criacao == PASSO_CONTRATO
          redirect_to visualizar_contrato_usuario_path(@usuario)
        elsif  @usuario.passo_criacao == PASSO_PLANO
          redirect_to editar_assinatura_usuario_path(@usuario)
        elsif @usuario.passo_criacao == PASSO_EMAIL
          @usuario.send_activation_email
          flash[:info] = t (:msg_info_verifique_email)
          redirect_to root_url
        end
      end
    else
      flash.now[:danger] = t :msg_erro_login
      render 'new'
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_url
  end
  
  private
    def bloquear?(usr)
      
      msg =  bloqueio(usr, BLOQUEIO_TODOS)
      if msg != ''
        if msg == 'msg_info_qtde_pombos_permitido'
          qtde = QTDE_POMBOS_BASICO
          
          flash[:danger] = t(msg, qtde: qtde, go: '')
        else
          flash[:danger] = t msg, go: ''
        end
        true
      else
        false
      end
      
    end
  
end
