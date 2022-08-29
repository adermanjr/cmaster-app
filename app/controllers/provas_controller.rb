class ProvasController < ApplicationController
  include MyModules::Util
  
  before_action :set_prova, only: [:show, :edit, :update, :destroy, :filter_by, :modal_nao_chegaram, :preparar_importacao, :importados, :preparo_prova]
  before_action :logged_in_user, only: [:new, :create, :edit, :update, :destroy, :preparo_prova]
  before_action :bloquear
  
  def modal_nao_chegaram
    usuario = current_user
    @pombos = Pombo.por_usuario(usuario.id).por_equipe(Equipe.por_usuario(usuario.id).last).sem_resultado(@prova.id)
    respond_to do |format|
      format.js 
    end
  end
  
  def save_pp
    @pp = ProvaPreparo.new(pp_params)
    @pp.usuario_id = current_user.id
    if @pp.save
      msg = "#{t :label_preparo} #{t :msg_info_criado_com_sucesso}"
      respond_to do |format|
        format.js { flash.now[:success] =  msg}
      end
    else
      render :modal_pp
    end
    
  end
  
  def modal_pp
    @usr = current_user
    @desc = ""
    @prova = Prova.find(params[:id])
    @pp = ProvaPreparo.find_by(prova_id: @prova, usuario_id: @usr) || ProvaPreparo.new(prova_id: @prova.id, usuario_id: @usr)
    preparo = Preparo.find_by(id: @pp.preparo_id)
    @desc = preparo.descricao if preparo
    
    respond_to do |format|
      format.js 
    end
  end
  
  def recupera_desc
    @desc = Preparo.find_by(id: params[:id]).descricao || ''
    respond_to do |format|
      format.js
    end
  end
  
  def preparar_importacao
    @usuario = current_user
  end
  
  def importados
    @msgs = []
    @usuario = current_user
    if @usuario.admin?
      if usuario = Usuario.find_by(id: params[:id_usuario_sistema])
        id_usu = usuario.id
      else
        @msgs << "#{t :msg_erro_usuario_nao_encontrado_sistema} #{params[:id_usuario_sistema]}"
        render :preparar_importacao
        return
      end
    else
      id_usu = @usuario.id
    end
    if params[:tipo_arquivo] == "TAURIS"
      msgs =  ResultadoImportado.import_file_txt_tauris(params[:file], id_usu, @prova.id)
    elsif params[:tipo_arquivo] == "XLS"
      msgs =  ResultadoImportado.import_file_xls(params[:file], params[:id_usuario_filter], id_usu, @prova.id)
    end
    
    if msgs.size == 0
      flash[:success] = "#{t :label_arquivo} #{t :msg_info_adiciado_com_sucesso}"
    else
      msgs.each do |m| 
        @msgs << "#{t m[:msg]} #{m[:campo]}"
      end
    end
    render :preparar_importacao
  end
  
  def filter_by
    @resultados = Resultado.por_prova(@prova).por_anilha(params[:anilha_filter])
    
    respond_to do |format|
      format.js 
    end
  end
  
  def show_modal_result
    @modal = params[:acao]
    if @modal == MODAL_PRV_RESUL
      
      @prova_modal = Prova.find(params[:id])
      
      if params[:r_id].blank?
        @result = Resultado.new
        @result.prova = @prova_modal
        @result.dhrestimada = Time.now.in_time_zone(current_user.fuso).strftime(mask_data_string_ruby)
        @result.dhroficial = Time.now.in_time_zone(current_user.fuso).strftime(mask_data_string_ruby)
      else
        @result = Resultado.find(params[:r_id])
      end
      @opcao_result = params[:opcao_result]
    elsif @modal == MODAL_PRV_ROTA
      @prova = Prova.find(params[:id])
      @usuario = current_user
    elsif @modal == GET_PRV_COORD
      puts 'get coords'
    end
    
    respond_to do |format|
      format.js
    end
  end
  
  def create_result
    
    id_result = params['resultado']['id']
    if id_result.present?
      @result = Resultado.find(id_result)
    else
      @result = Resultado.new()
      @result.pombo_id = params['resultado']['pombo_id']
      @result.prova_id = params['resultado']['prova_id']
    end
    
    @result.usuario_id = current_user.id
    
    if params['resultado'][:opcao_result] == 'P'
      @result.dhrestimada = Time.zone.parse(params['resultado']['dhrestimada'])
    else
      @result.dhroficial = Time.zone.parse(params['resultado']['dhroficial'])
      @result.posicao = params['resultado']['posicao']
      @result.pontos = params['resultado']['pontos']
      @result.dist_oficial = params['resultado']['dist_oficial']
      @result.veloc_oficial = params['resultado']['veloc_oficial']
    end
    
    if @result.save
      @prova_modal = @result.prova
      redirect_to @prova_modal
      flash[:success] = t(:label_marcacao) + " " + t(:msg_info_criado_com_sucesso)
    else
      render :show_modal_result
    end
    
  end
  
  def destroy_result
    result = Resultado.find(params[:id])
    @prova = result.prova
    result.destroy
    
    redirect_to @prova
    flash[:success] = t(:label_marcacao) + " " + t(:msg_info_excluido_com_sucesso)
  end

  # GET /provas
  def index
    @provas = Prova.all.order(dtsolta: :desc)
  end

  # GET /provas/1
  def show
    @resultados = @prova.resultados
    @result_dl = @resultados.map{ |r| r.pombo }.map{ |p| p.anilha}.sort
    
    if Resultado.por_prova(@prova).oficial.count > 0
      params[:lista_result] = 'O'
    else
      params[:lista_result] = 'P'
    end
  end
  
  # GET /provas/new
  def new
    @prova = Prova.new
    if params['competicao_id'].present?
      @prova.competicao_id = params['competicao_id']
    end
  end

  # GET /provas/1/edit
  def edit
    @prova.usuario = current_user
  end

  # POST /provas
  # POST /provas.json
  def create
    @prova = Prova.new(prova_params)
    @prova.usuario = current_user
    if (@prova.lat.blank?) 
      @prova.update(lat: dms_to_degrees(@prova.lat_deg, @prova.lat_min, @prova.lat_seg, @prova.lat_card), 
                                lng: dms_to_degrees(@prova.lng_deg, @prova.lng_min, @prova.lng_seg, @prova.lng_card))
    end
    
    if @prova.save
      redirect_to @prova
      flash[:success] = t(:label_prova) + " " + t(:msg_info_criado_com_sucesso)
    else
      render :new
    end
  end

  # PATCH/PUT /provas/1 
  def update
    if @prova.update(prova_params)
      redirect_to @prova
      flash[:success] = t(:label_prova) + " " + t(:msg_info_atualizado_com_sucesso)
    else
      render :edit
    end
  end

  # DELETE /provas/1
  def destroy
    @prova.resultados.each do |r|
      r.destroy
    end
    
    @prova.destroy
    redirect_to provas_url
    flash[:success] = t(:label_prova) + " " + t(:msg_info_excluido_com_sucesso) 
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_prova
      @prova = Prova.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def prova_params
      params.require(:prova).permit(:nome, :dtsolta, :tipo, :competicao_id, :lat, :lng, :usuario_id, :lat_card, :lat_deg, :lat_min, :lat_seg, :lng_card, :lng_deg, :lng_min, :lng_seg)
    end
    
    def result_params
      params.require(:resultado).permit(:dhrestimada, :dhroficial, :posicao, :pontos, :pombo_id, :prova_id, :id)
    end
    
    def pp_params
      params.require(:prova_preparo).permit(:preparo_id, :prova_id)
    end
    
    def mask_data_string_ruby
      if session[:locale] == "en"
        '%m/%d/%Y %H:%M:%S%z'
      else
        '%d/%m/%Y %H:%M:%S%z'
      end
    end
    
    def bloquear
      usr = current_user
      msg =  bloqueio(usr, BLOQUEIO_PAGTO)
      if msg != ''
        flash[:danger] = t msg
        redirect_to detalhar_assinatura_usuario_path(usr)
      end
    end
    
end
