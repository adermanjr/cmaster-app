class ResultadoImportado < ApplicationRecord
  require 'roo'
  
  @itens = []
  
  @pombo = nil
  
  def self.valida(item)
    msgs = []
    if !item['ring']
      msgs << {campo: "ring", msg: "msg_erro_anilha_nao_encontrada"}
    end
    
    if !item['classif']
      msgs << {campo: "classif", msg: "msg_erro_complemento_nao_esta_preenchido"}
    elsif !item['classif'].is_a?(Numeric)
      msgs << {campo: "classif", msg: "msg_erro_campo_nao_numerico"}
    end
    
    if !item['points']
      msgs << {campo: "points", msg: "msg_erro_complemento_nao_esta_preenchido"}
    elsif !item['points'].is_a?(Numeric)
      msgs << {campo: "points", msg: "msg_erro_campo_nao_numerico"}
    end
    
    if !item['distance']
      msgs << {campo: "distance", msg: "msg_erro_complemento_nao_esta_preenchido"}
    elsif !item['distance'].is_a?(Numeric)
      msgs << {campo: "distance", msg: "msg_erro_campo_nao_numerico"}
    end
    
    if !item['veloc']
      msgs << {campo: "veloc", msg: "msg_erro_complemento_nao_esta_preenchido"}
    elsif !item['veloc'].is_a?(Numeric)
      msgs << {campo: "veloc", msg: "msg_erro_campo_nao_numerico"}
    end
    
    if item['year']
      if !item['year'].is_a?(Numeric)
        msgs << {campo: "year", msg: "msg_erro_campo_nao_numerico"}
      end
    end
    
    if !item['time']
      msgs << {campo: "time", msg: "msg_erro_complemento_nao_esta_preenchido"}
    end
    
    msgs
    
  end
  
  def self.import_records(file, id_usuario_filter)
    spreadsheet = Roo::Spreadsheet.open(file.path)
    header = spreadsheet.row(1)
    msgs = []
    @itens = []
    
    (2..spreadsheet.last_row).map do |i|
      row = Hash[[header, spreadsheet.row(i)].transpose]
      #item = Item.find_by_id(row["id"]) || Item.new
      map_ri = row.to_hash
      if map_ri['idcriador'].to_i == id_usuario_filter.to_i
        begin
          item = ResultadoImportado.new(map_ri)
          msgs_v = self.valida(item)
          if msgs_v.size == 0
            @itens << item
          else
            msgs << msgs_v
          end
        rescue ActiveModel::UnknownAttributeError => e
          msgs << {campo: "", msg: e}
        end
      end
    end
    
    msgs
    
  end
  
  def self.generate_resultado(import_file)
    msgs = []
    @itens = []
    
    File.foreach( import_file.path, encoding: 'iso-8859-1:utf-8').with_index do |line, index|
      num_linha = line[5,4]
      ano = line[18,2]
      anilha = line[21,9]
      sex = line[30,1]
      cor = line[33,3]
      dia_cheg = line[50,2]
      hora_cheg = line[53,8]
      
      if is_num?(num_linha) && is_num?(ano) && is_num?(dia_cheg)
        puts "num_linha #{num_linha} ano #{ano} anilha #{anilha.gsub!(/\s+/, '')} sex #{sex} cor #{cor.gsub!(/\s+/, '')} dia_cheg #{dia_cheg} hora_cheg #{hora_cheg}"
        item = {'ring': anilha, 'year': ano, 'sex': sex, 'color': cor, 'day_arrive': dia_cheg, 'time_arrive': hora_cheg}
        @itens << item
      end
    end
    msgs
  end
  
  def self.import_file_txt_tauris(import_file, id_usuario_sistema, prova_id)
    msgs = generate_resultado(import_file)
    return msgs if msgs.size > 0
    
    if @itens.size == 0
      msgs << {campo: "", msg: "msg_erro_arquivo_invalido"}
      return msgs
    end
    
    msgs = self.import_itens_tauris(id_usuario_sistema, prova_id)
    
    msgs
  end
  
  def self.is_num?(str)
    /\A[-+]?\d+\z/ === str
  end
  
  def self.import_file_xls(file, id_usuario_filter, id_usuario_sistema, prova_id)
    
    msgs = self.import_records(file, id_usuario_filter)
    return msgs if msgs.size > 0
    
    if @itens.size == 0
      msgs << {campo: id_usuario_filter, msg: "msg_erro_usuario_nao_encontrado_planilha"}
      return msgs
    end
    
    msgs = self.import_itens(id_usuario_sistema, prova_id)
    
    msgs
  end
  
  def self.setar_prombo(id_usuario_sistema, anilha, ano, sexo, cor)
    msgs = []
    
    @pombo = Pombo.por_usuario(id_usuario_sistema).por_anilha(anilha).first
        
    if !@pombo
      
      @pombo = Pombo.new
      @pombo.usuario_id = id_usuario_sistema
      @pombo.anilha = anilha
      @pombo.sexo = sexo
      @pombo.desc_cor = cor
      @pombo.cor_id = COR_NAO_INFORMADA
      if ano
        aux = ( ano.to_i/2000 > 0 ? ano.to_i : ano.to_i + 2000 )
        @pombo.dtnasc = Date.parse(aux.to_s + "-01-01")
      end
      
      if !@pombo.save
        @pombo.errors.full_messages.each do |m|
          msgs << {campo: m, msg: 'msg_erro_banco'}  
        end
      end
    end
    
    msgs
  end
  
  def self.import_itens(id_usuario_sistema, prova_id)
    msgs = []
    prova = Prova.find(prova_id)
    
    if @itens.map(&:valid?).all? 
      @itens.each do |item|
        
        msgs2 = self.setar_prombo(id_usuario_sistema, item['ring'], item['year'], 'F', nil)
        
        if msgs2.size > 0
          msgs << msgs2
        else
          resultados = Resultado.por_prova(prova_id).por_pombo(@pombo.id) 
          resultado = resultados[0] || Resultado.new
          resultado.pombo_id = @pombo.id
          resultado.prova_id = prova_id
          resultado.usuario_id = id_usuario_sistema
          resultado.posicao = item['classif']
          resultado.pontos = item['points']
          resultado.dist_oficial = item['distance']
          if item['veloc'].to_i.to_s.length >= 6
            veloc = item['veloc'] / 1000
          else
            veloc = item['veloc'] 
          end
          resultado.veloc_oficial = veloc
          if item['date']
            aux_date = item['date']
          else
            aux_date = prova.dtsolta.strftime("%Y-%m-%d")
          end
          dia = Time.zone.parse("#{aux_date} #{item['time']}")
          resultado.dhroficial = dia
          
          if !resultado.save
            resultado.errors.full_messages.each do |m|
              msgs << {campo: m, msg: 'msg_erro_banco'}
            end
          end
        end
          #@itens.each(&:save!)
        # else
        #   msgs << {campo: item['ring'], msg: "msg_erro_anilha_nao_encontrada"}
        # end
      end
    else
      @itens.each_with_index do |item, index|
        item.errors.full_messages.each do |m|
          msgs << {campo: "#{index + 6}: #{m}", msg: 'msg_erro_banco'}
        end
      end
    end
    msgs
  end
  
  def self.import_itens_tauris(id_usuario_sistema, prova_id)
    msgs = []
    prova = Prova.find(prova_id)
    
    @itens.each do |item|
      puts "item #{item}"
      msgs2 = self.setar_prombo(id_usuario_sistema, item[:ring], item[:year], item[:sex], item[:color])
      
      if msgs2.size > 0
        msgs << msgs2
      else
        resultados = Resultado.por_prova(prova_id).por_pombo(@pombo.id) 
        resultado = resultados[0] || Resultado.new
        resultado.pombo_id = @pombo.id
        resultado.prova_id = prova_id
        resultado.usuario_id = id_usuario_sistema
        aux_date = prova.dtsolta.strftime("%Y-%m-%d")
        dia = Time.zone.parse("#{aux_date} #{item[:time_arrive]}")
        
        dia = dia + 1.day if aux_date[-2,2] != item[:day_arrive]
        
        resultado.dhrestimada = dia
        
        if !resultado.save
          resultado.errors.full_messages.each do |m|
            msgs << {campo: m, msg: 'msg_erro_banco'}
          end
        end
      end
    end
    
    msgs
  end

end
# https://rubyplus.com/articles/4131-Import-Records-from-CSV-and-Excel-in-Rails-5
# https://mattboldt.com/importing-massive-data-into-rails/
# https://medium.com/@JasonCodes/ruby-on-rails-importing-from-excel-1504fd99a35e
# ActiveSupport::TimeZone.all.sort_by(&:name).map{|tz| [tz.utc_offset, tz.name]}
# https://stackoverflow.com/questions/16818180/ruby-rails-change-the-timezone-of-a-time-without-changing-the-value