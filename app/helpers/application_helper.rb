module ApplicationHelper
    # Returns the full title on a per-page basis.
  def full_title(page_title = '')
    base_title = t :columba_master
    if page_title.empty?
      base_title
    else
      base_title + " | " + page_title
    end
  end
  
  def cores_for_select
    Cor.all.order(:nome).map{ |c| [t(c.nome), c.id]}
  end
  
  def botao_estilo
    'btn btn-primary btn-block'
  end
  
  def botao_estilo_menu
    'btn btn-danger btn-block'
  end
  
  def botao_link
    'btn btn-outline-secondary btn-sm text-dark'
  end
  
  def tipo_prova_for_select
    [[t(:label_tipo_prova_1), 1],[t(:label_tipo_prova_2), 2],[t(:label_tipo_prova_3), 3]]
  end 
  
  def intervalos_for_select
    [[t(:label_intervalo_S), "S"],[t(:label_intervalo_Q), "Q"],[t(:label_intervalo_M), "M"],[t(:label_intervalo_A), "A"]]
  end
  
  def tipo_arquivo_for_select
    [["TauRIS Print", "TAURIS"], ["Excel", "XLS"]]
  end
  
  def pombal_for_select
    Pombal.por_usuario(current_user.id).ativo.order(:nome).map{ |p| [p.nome, p.id]}
  end
  
  def usuario_for_select
    Usuario.where(activated: 't').where(admin: nil).order(:nome).map{ |c| ["#{c.id}-#{c.nome}", c.id]}
  end
  
  def competicao_for_select
    Competicao.all.order('created_at DESC').map{ |c| ["#{c.ano}-#{c.nome}-#{Clube.find(c.clb_id).nome}", c.id]}
  end
  
  def medidas_for_select
    [[t(:label_medida_ML), "ML"],[t(:label_medida_LT), "LT"],[t(:label_medida_GR), "GR"],[t(:label_medida_KG), "KG"],[t(:label_medida_CO), "CO"]]
  end
  
  def tratamento_for_select
    Tratamento.por_usuario(current_user.id).order(:nome).map{ |t| [t.nome, t.id]}
  end
  
  def pombo_for_select
    equipe = Equipe.por_usuario(current_user).last
    if  equipe != nil && equipe.pombos.count > 0
      equipe.pombos.order(:anilha).map{ |p| ["#{p.anilha} #{p.nome}", p.id]}
    else
      Pombo.por_usuario(current_user.id).esta_vivo('t').order(:anilha).map{ |p| ["#{p.anilha} #{p.nome}", p.id]}
    end
    
  end
  
  def timezone_for_select
    #[tz.utc_offset, tz.name]
    ActiveSupport::TimeZone.all.sort_by(&:name).map{|tz| [tz.name, tz.name]}
  end
  
  def uf_for_select(filtrar)
    Estado.que_tem_clube(filtrar).order(:nome).map{ |e| [e.nome, e.id]}
  end
  
  def preparo_for_select
    Preparo.por_usuario(current_user.id).order(:nome).map{ |p| [p.nome, p.id]}
  end
  
  def clube_for_select(est_id)
    if est_id.present?
      Clube.por_estado(est_id).order(:nome).map{ |c| [c.nome, c.id]}
    else
      [["", ""]]
    end
  end
  
  def nacao_for_select(filtro)
    Nacao.por_locale(filtro).order(:nome).map{ |n| [n.nome, n.id]}
  end
  
  def path_para_aplicacao(tipo)
    if tipo == 'T' 
      gerar_aplicacao_tratamentos_path
    elsif tipo == 'P'
      gerar_aplicacao_pombos_path
    else
      gerar_aplicacao_pombals_path
    end
  end
  
  def bandeira_cc(usuario)
    locale = "pt-BR"
    locale = usuario.lingua if ! usuario.lingua.blank?
    
    if locale == "pt-BR"
      [["Visa","Visa"], ["Master","Master"], ["Amex","Amex"], ["Elo","Elo"], ["Aura","Aura"], ["Diners","Diners"], ["JCB","JCB"], ["Discover","Discover"], ["Hipercard","Hipercard"]]
    end
  end
  
  def locale
    [['Português','pt-BR'], ['English','en']]
  end
  
  def combo_moeda
    [[t(:label_moeda_BRL), MOEDA_BRL], [t(:label_moeda_EUR), MOEDA_EUR], [t(:label_moeda_USD), MOEDA_USD]]
  end
  
  def velocidade_mm(prova, dhref, usuario_id )
    return 0 if dhref.blank?
    usr = Usuario.find(usuario_id)
    distancia = calcula_distancia_metros(prova.lat.to_f, prova.lng.to_f, usr.lat.to_f, usr.lng.to_f)
    distancia / (( dhref - prova.dtsolta)/1.minutes)
  end
  
  def nome_plano(plano)
    if plano == nil
      t :label_plano_B
    else
      "#{t("label_plano_#{plano.tipo}")}"
    end
  end
  
# Elipsóide	SIRGAS2000
# a	6.378.137,000
# b	6.356.752,310
	
# Elipsóide	CÓRREGO ALEGRE
# a	6.378.388,000
# b	6.356.912,000
  
  def calcula_distancia_metros(p1lat, p1lng, p2lat, p2lng)
    radius = 6378137 ### Earth’s mean radius in meter
    dLat = radMath(p2lat - p1lat)
    dLng = radMath(p2lng - p1lng)
    a = Math.sin(dLat / 2) * Math.sin(dLat / 2) + Math.cos(radMath(p1lat)) * Math.cos(radMath(p2lat)) * Math.sin(dLng / 2) * Math.sin(dLng / 2)
    c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a))
    radius * c
  end
  
  def calcula_distancia_km(p1lat, p1lng, p2lat, p2lng)
    calcula_distancia_metros(p1lat, p1lng, p2lat, p2lng)/1000
  end
  
  def calcula_distancia_km_por_usr(prova, usuario_id)
    usr = Usuario.find(usuario_id)
    calcula_distancia_km(prova.lat.to_f, prova.lng.to_f, usr.lat.to_f, usr.lng.to_f)
  end
    
  def radMath(val)
    val * Math::PI / 180
  end
  
  def mask_cep
    "'mask': '99999-999'"
  end
  
  def mask_tel
    "'mask': '(99) 9999[9]-9999'"
  end
  
  def mask_cartao
    "'mask': '9999-9999-9999-9999'"
  end
  
  def mask_vencto_cartao
    "'alias': 'mm/yyyy'"
  end
  
  def mask_data
    if session[:locale] == "en"
      "'alias': 'mm-dd-yyyy'"
    else
      "'alias': 'dd/mm/yyyy'"
    end
  end
  
  def mask_hora
    "'alias': 'HH:MM:ss'"
  end
  
  def usuario_degas(user)
    user.tipo_usuario == USUARIO_MODERADOR || user.admin
  end
  
  def estilo_card_footer_plano(tela)
    if tela == INI_PAGE
      'card-footer caixa_plano_105'
    else
      'card-footer caixa_plano_g'
    end
  end
  
  def fundo_tipo_prova(tipo)
    if tipo == 1
      'success'
    elsif tipo == 2
      'primary'
    else
      'secondary'
    end
  end
end
