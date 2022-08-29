module SessionsHelper
  include MyModules::PagamentoCielo
  include MyModules::LibPaypal
  
  # Logs in the given user.
  def log_in(usuario)
    session[:user_id] = usuario.id
    session[:locale] = usuario.lingua
    I18n.locale = usuario.lingua
  end
  
  # Remembers a user in a persistent session.
  def remember(usuario)
    usuario.remember
    cookies.permanent.signed[:user_id] = usuario.id
    cookies.permanent[:remember_token] = usuario.remember_token
  end
  
  # Returns true if the given user is the current user.
  def current_user?(usuario)
    usuario == current_user
  end
  
  # Returns the user corresponding to the remember token cookie.
  def current_user
    if (user_id = session[:user_id])
      @current_user ||= Usuario.find_by(id: user_id)
    elsif (user_id = cookies.signed[:user_id])
      usuario = Usuario.find_by(id: user_id)
      if usuario && usuario.authenticated?(:remember, cookies[:remember_token])
        log_in usuario
        @current_user = usuario
      end
    end
  end
  
  # Returns true if the user is logged in, false otherwise.
  def logged_in?
    !current_user.nil?
  end
  
  # Forgets a persistent session.
  def forget(user)
    user.forget
    cookies.delete(:user_id)
    cookies.delete(:remember_token)
  end
  
  # Logs out the current user.
  def log_out
    forget(current_user)
    session.delete(:user_id)
    @current_user = nil
  end
  
  # Redirects to stored location (or to the default).
  def redirect_back_or(default)
    if session[:forwarding_url]
      page_redirect = session[:forwarding_url] + "?locale=#{current_user.lingua}"
    else 
      page_redirect = "/usuarios/#{default.id}?locale=#{current_user.lingua}"
    end
    
    redirect_to(page_redirect)
    session.delete(:forwarding_url)
  end

  # Stores the URL trying to be accessed.
  def store_location
    session[:forwarding_url] = request.original_url if request.get?
  end
  
  def autor_info(usuario)
    if usuario == nil || !logged_in?
      false
    else
      current_user.id == usuario.id
    end
  end
  
  def bloqueio_por_limite_qtde(usuario, plano)
    
    return false if plano.tipo == PLANO_ILIMITADO || plano.tipo == PLANO_MASTER || usuario.tipo_usuario == USUARIO_MODERADOR
    
    if usuario.pombos.present?
      qtde = usuario.pombos.count
    else
      qtde = 0
    end
    
    if (plano.tipo == PLANO_BASICO && qtde > QTDE_POMBOS_BASICO)
      true
    else
      false
    end
  end
  
  def bloqueio_por_vencto(usuario, plano)
    if plano.dtcancelamento.present? && plano.dtcancelamento <= Time.now
      true
    else
      false
    end
  end
  
  def bloqueio_por_pagto(usuario, plano)
    
    ret = get_subscription(ambiente_pagto, plano.id_recorrencia_operadora)
    if !ret[:success]
      false
    else
      puts ret[:body]["status"]
      if !PAYPAL_SUCESSO.include? ret[:body]["status"]
        true
      else
        false
      end
    end
  end
=begin    
    response = consultar_pagamento(ambiente_pagto, plano)
      
    if CIELO_SUCESSO.include? response.code
      @retorno = JSON.parse(response.body)
      if CIELO_PAGTO_OK.include? @retorno["RecurrentPayment"]["Status"]
        true
      else
        false
      end
    end
=end    
  
  def bloqueio(usuario, tipo_bloqueio)
    
    return '' if usuario == nil || !logged_in?
    
    return '' if usuario.tipo_usuario == USUARIO_MODERADOR || usuario.admin
    
    plano = usuario.planos.last if usuario.planos.present?
    
    return '' if plano.tipo == PLANO_AVALIACAO
    
    return 'msg_erro_plano_cancelado' if plano.dtcancelamento != nil && Time.now > plano.dtcancelamento
    
    if tipo_bloqueio == BLOQUEIO_LIMITE_QTD || tipo_bloqueio == BLOQUEIO_TODOS
      return 'msg_info_qtde_pombos_permitido' if bloqueio_por_limite_qtde(usuario, plano)
    end
    
    if plano.tipo != PLANO_BASICO && (tipo_bloqueio == BLOQUEIO_PAGTO || tipo_bloqueio == BLOQUEIO_TODOS)
      return 'msg_erro_plano_cancelado' if bloqueio_por_vencto(usuario, plano)
      return 'msg_erro_pagmento_nao_confirmado' if bloqueio_por_pagto(usuario, plano)
    end
    
    return ''
  end
  
  def ambiente_pagto
    if ENV['RAILS_ENV'] == 'production'
      'producao'
    else
      'sandbox' 
    end
  end
  
  def mask_data_ruby
    if session[:locale] == "en"
      '%m/%d/%Y'
    else
      '%d/%m/%Y'
    end
  end
  
  def mask_datahora_ruby
    if session[:locale] == "en"
      '%m/%d/%Y %H:%M:%S'
    else
      '%d/%m/%Y %H:%M:%S'
    end
  end
  
  def mask_datahora_sem_segundos
    if session[:locale] == "en"
      '%m/%d/%Y %H:%M'
    else
      '%d/%m/%Y %H:%M'
    end
  end
end
