module UsuariosHelper
  
  # Returns the Gravatar for the given user.
  def gravatar_for(usuario)
    gravatar_id = Digest::MD5::hexdigest(usuario.email.downcase)
    gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}"
    image_tag(gravatar_url, alt: usuario.nome, class: "gravatar")
  end
  
  def status_assinatura(plano)
    if !plano.dtcancelamento.present?
      'label_ativo'
    else
      if Time.now > plano.dtcancelamento
        'label_cancelado'
      else
        'label_a_cancelar'
      end
    end
  end
  
  def class_status_assinatura(plano)
    if !plano.dtcancelamento.present?
      'text-success'
    else
      'text-danger'
    end
  end
  
  def paypal_plan_id(usuario)
    if usuario.id < 1
      PAYPAL_CODE_BRL
    elsif usuario.id >= 2
      PAYPAL_CODE_USD
    else 
      PAYPAL_CODE_EUR
    end
    
  end
  
end
