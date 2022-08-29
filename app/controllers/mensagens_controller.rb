class MensagensController < ApplicationController
  def new
    @mensagem = Mensagem.new
  end
  
  def create
    @mensagem = Mensagem.new message_params

    date_check = DateTime.strptime(params['recaptcha_validation'], '%Q') if params['recaptcha_validation']
    if !date_check || 2.minutes.ago > date_check
      flash[:danger] = t :msg_erro_email_nao_enviado_recaptcha
      render 'new'
    else
      if @mensagem.valid?
        MessageMailer.contact_me(@mensagem).deliver_now
        flash[:success] = t :msg_info_email_enviado_contato
        redirect_to faleconosco_path
      else
        flash[:danger] = t :msg_erro_email_nao_enviado
        render 'new'
      end
    end 
  end
  
  private

    def message_params
      params.require(:mensagem).permit(:nome, :email, :body, :telefone)
    end
  
end
