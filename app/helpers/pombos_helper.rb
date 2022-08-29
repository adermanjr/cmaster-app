module PombosHelper
  def age(dob)
    now = Time.now.utc.to_date
    ret = now.year - dob.year - ((now.month > dob.month || (now.month == dob.month && now.day >= dob.day)) ? 0 : 1)
    ret.to_i
  end
  
  def icon_pombo(sexo)
    if sexo != nil
      if sexo == 'F' || sexo == 'MAE'
        file_img = 'pombo-femea.png'
      else
        file_img = 'pombo-macho.png'
      end
      image_tag(file_img, alt: "", size: "20")
    end
  end
  
  def logo_fb
    image_tag('fb_logo.png', alt: "Compartilhe!", size: "20")
  end
  
  def logo_wz
    image_tag('whats_logo.png', alt: "Compartilhe!", size: "20")
  end
  
  def class_pombo_pais(estilo)
    estilo_classe = 'card-header small'
    if estilo == '1'
      estilo_classe
    elsif estilo == '2'
      estilo_classe += ' caixa_pai'
    elsif estilo == '3'
      estilo_classe += ' caixa_mae'
    elsif estilo == '4'
      estilo_classe += ' caixa_pai_escuro'
    elsif estilo == '5'
      estilo_classe += ' caixa_pai_claro'
    elsif estilo == '6'
      estilo_classe += ' caixa_mae_escuro'
    elsif estilo == '7'
      estilo_classe += ' caixa_mae_claro'
    end
  end
  
  def class_pombo_famila(estilo)
    estilo_classe = 'card-header small'
    if estilo == 'PAI'
      estilo_classe += ' caixa_pai'
    elsif estilo == 'MAE'
      estilo_classe += ' caixa_mae'
    else
      estilo_classe += ' bg-light'
    end
  end
  
  def pais_for_select(sexo, id)
    filtro = " usuario_id = #{current_user.id} and sexo = '#{sexo}'"
    if id != nil
       filtro += " and id not in (#{id}) "
    end
    Pombo.where(filtro).map{ |p| ["#{p.anilha} #{p.nome}", p.id]}
  end
  
  def parente_nome(pombo, tipo)
    if tipo =='P'
      if pombo.pai_id != nil && pombo.pai
        "#{pombo.pai.anilha} #{pombo.pai.nome}"
      else
        nil
      end
    else
      if pombo.mae_id != nil && pombo.mae
        "#{pombo.mae.anilha} #{pombo.mae.nome}"
      else
        nil
      end
    end
  end
  
  def ancestral_pai(pombo, n)
    if pombo == nil
      nil
    elsif n > 0 
      if pombo.pai_id == nil
        nil
      else
        ancestral_pai(pombo.pai, (n-1))
      end
    else
      if pombo.pai_id != nil
        pombo.pai
      end
    end
  end
  
  def ancestral_mae(pombo, n)
    if pombo == nil
      nil
    elsif n > 0 
      if pombo.mae_id == nil
        nil
      else
        ancestral_mae(pombo.mae, (n-1))
      end
    else
      if pombo.mae_id != nil
        pombo.mae
      end
    end
  end
  
  def titulo_panel(tipo)
    if tipo == 'PAI'
      t(:label_pai)
    elsif tipo == 'MAE'
      t(:label_mae)
    elsif tipo == 'F1'
      t(:label_filho) + ' 1'
    else
      t(:label_filho) + ' 2'
    end
  end
  
  def visivel_correct_user(id)
    pombo = current_user.pombos.find_by(id: id)
    pombo.nil?
  end
  
  def visivel(user_id)
    if current_user
      current_user.id == user_id
    else
      false
    end
  end
  
end
