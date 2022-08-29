class PombosController < ApplicationController
  before_action :set_pombo, only: [:show, :edit, :update, :destroy]
  before_action :logged_in_user, only: [:new, :create, :edit, :update, :destroy, :familia, :familia_create] #, :show
  before_action :correct_user,   only: [:edit, :update, :destroy] #, :show
  before_action :bloquear_limite, only: [:new, :create, :familia, :familia_create]
  before_action :bloquear_vencto, only: [:new, :create, :familia, :familia_create, :index, :edit]
  
  def show_modal_parents
    @tipo = params[:tipo_parente]
    @pombo = Pombo.find(params[:pombo_id]) if !params[:pombo_id].blank?
    @msgs = []
    if !params[:parent_id].blank?
      if @tipo == 'PAI'
        @pombo_parent = @pombo.pai if ! @pombo.blank?
      else
        @pombo_parent = @pombo.mae if ! @pombo.blank?
      end 
    else
      @pombo_parent = Pombo.new
    end
    
  end
  
  def save_parents
    @msgs = []
    @tipo = params[:tipo_parente]
    if params[:parent_id].blank?
      
      if @tipo == 'PAI'
        @pombo_parent = criar('pai','M', t(:label_pai), true)
      else
        @pombo_parent = criar('mae','F', t(:label_mae), true)
      end
    else
      @pombo_parent = Pombo.find(params[:parent_id])
      @pombo_parent.update(parente_params(@tipo.downcase))  
    end 
    if @msgs.count == 0
      @pombo_parent.save
      @msgs << t("label_#{@tipo.downcase}") + " " + t(:msg_info_criado_com_sucesso)
    
      respond_to do |format|
        format.js
      end
    else
      puts 'erro save_parents ini'
      puts @msgs
      puts 'erro save_parents fim'
      render :show_modal_parents
    end
    
  end
    
  def create_titulo
    @titulo = Titulo.new(titulo_params)
    @pombo_modal = Pombo.find(@titulo.pombo_id)
    if @titulo.save
      msg = "#{t :label_premio} #{t :msg_info_criado_com_sucesso}"
      respond_to do |format|
        format.js { flash.now[:success] =  msg}
      end
    else
      render :show_modal
    end
  end
  
  def destroy_titulo
    tit = Titulo.find(params[:id])
    @pombo_modal = Pombo.find(tit.pombo_id)
    tit.destroy
    respond_to do |format|
      format.js {flash.now[:success] = t(:label_premio) + " " + t(:msg_info_excluido_com_sucesso)}
    end
  end
  
  def show_modal
    @pombo_modal = Pombo.find(params[:id])
    
    if params[:tela] == 'M'
      @tela_modal = 'modal'
    else 
      @tela_modal = 'modal_titulos'
      @titulo = Titulo.new
    end
    
    respond_to do |format|
      format.js
    end
  end
  
  def autocomplete
    if params[:pesquisa].present?
      anilha = params[:pesquisa]
    else
      anilha = params[:pesquisa_result]
    end
    @pombos = Pombo.por_usuario(current_user.id).anilha_like(anilha)
    render json: @pombos
  end
  
  def show_modal_aplicacao
    @objeto = Pombo.find(params[:id])
    @tipo = 'P'
    respond_to do |format|
      format.js
    end
  end
  
  def gerar_aplicacao
    @msgs = Array.new
    if valida_aplicacao(params[:tratamento_id], params[:dtini_par], params[:dosagem_par], params[:medida_par])
      
      aplicacao = Aplicacao.new(pombo_id: params[:id], tratamento_id: params[:tratamento_id], dtaplicacao: params[:dtini_par], dosagem: params[:dosagem_par], medida: params[:medida_par])
      if !aplicacao.save
        respond_to do |format|
          format.js { flash.now[:danger] = aplicacao.errors }
        end
      end
      
      redirect_to pombos_path
      flash[:success] = t(:label_aplicacao) + " " + t(:msg_info_criado_com_sucesso)
    else
      respond_to do |format|
        format.js { flash.now[:danger] = @msgs }
      end
    end
  end
  
  def valida_aplicacao(tratamento, dtini, dosagem, medida)
    ok = true
    
    if tratamento.blank? 
      @msgs << "#{t :label_tratamento} #{t('errors.messages.required')}"
      ok = false
    end
    
    if dtini.blank? 
      @msgs << "#{t :label_data_inicio} #{t('errors.messages.required')}"
      ok = false
    end
    
    if dosagem.blank?
      @msgs << "#{t :label_dosagem} #{t('errors.messages.required')}"
      ok = false
    end
    
    if medida.blank?
      @msgs << "#{t :label_medida} #{t('errors.messages.required')}"
      ok = false
    end
    
    return ok
  end
  
  def familia_create
    
    @msgs = []
    
    @pomboPai = criar('pai','M', t(:label_pai), params['pai_incluir'])
    @pomboMae = criar('mae','F', t(:label_mae), params['mae_incluir'])
    @pomboFilho1 = criar('f1', nil, t(:label_filho) + ' 1', params['f1_incluir'])
    @pomboFilho2 = criar('f2', nil, t(:label_filho) + ' 2', params['f2_incluir'])
    
    if @msgs.count == 0
      pai_id = nil
      mae_id = nil
      
      if params['pai_incluir'] 
        @pomboPai.save
        pai_id = @pomboPai.id
      end
      
      if params['mae_incluir']
        @pomboMae.save
        mae_id = @pomboMae.id
      end
      
      if params['f1_incluir']
        @pomboFilho1.pai_id = pai_id
        @pomboFilho1.mae_id = mae_id
        @pomboFilho1.save
      end

      if params['f2_incluir']
        @pomboFilho2.pai_id = pai_id
        @pomboFilho2.mae_id = mae_id
        @pomboFilho2.save
      end
      
      flash[:success] = t(:label_familia) + " " + t(:msg_info_criado_com_sucesso)
      redirect_to pombos_path
    else
      render :familia
    end
    
  end
  
  def valida_membro(pombo, label)
    anilha_valid =  pombo.anilha
    if pombo.sexo.blank?
      @msgs << "<b>#{label}</b>: "
      @msgs << t(:msg_erro_campo_nao_informado, campo: t(:label_sexo))
    end
    if !pombo.valid?
      @msgs << "<b>#{label}</b>: "
      @msgs << pombo.errors.full_messages
    else
      if !pombo.anilha.blank?
        p = Pombo.por_usuario(current_user.id).por_anilha(anilha_valid)
        if p.count > 0
          @msgs << "<b>#{label}</b>: "
          @msgs << t(:msg_erro_anilha_cadastrada)
        end
        pombo.anilha = anilha_valid
      #else
      #  @msgs << "<b>#{label}</b>: "
      #  @msgs << t(:msg_erro_campo_nao_informado, campo: t(:label_anilha))
      end
    end
  end
  
  def criar(tipo, sexo, label, incluir)
    pombo = Pombo.new(parente_params(tipo))
    pombo.cor_id = COR_NAO_INFORMADA
    pombo.usuario = current_user
    if sexo != nil
      pombo.sexo = sexo
    end
    if incluir
      valida_membro(pombo, label)
    end
    return pombo
  end
  
  def familia
    @pomboPai = Pombo.new
    @pomboMae = Pombo.new
    @pomboFilho1 = Pombo.new
    @pomboFilho2 = Pombo.new
  end
  
  def index
    user = current_user
    @pombos = Pombo.por_usuario(user).paginate(page: params[:page], :per_page => 20)
    @all_pombos = Pombo.por_usuario(user).order('anilha').select('anilha, sexo')
    @pombos_dl = @all_pombos.map{|p| p.anilha }
    @pombos_dl_femeas = @all_pombos.select{ |p| p.sexo == 'F' }.map{|p| p.anilha }
    @pombos_dl_machos = @all_pombos.select{ |p| p.sexo == 'M' }.map{|p| p.anilha }
    
    @qtde = Pombo.por_usuario(user).count
    
    # if @pombos.size == 0
    #   redirect_to familia_path
    # end
    
    plano = user.planos.last
    flash.now[:danger] = t :msg_info_qtde_pombos_permitido, qtde: QTDE_POMBOS_BASICO if  bloqueio_por_limite_qtde(user, plano)
    
  end
  
  def filter_by
    
    vivo_par = nil
    if !params[:vivo_filter].blank?
      if params[:vivo_filter]
        vivo_par = 't'
      end
    end
    
    @pombos = Pombo.por_usuario(current_user.id).esta_vivo(vivo_par).anilha_like(params[:anilha_filter]).por_pai(params[:pai_filter],params[:pai_filter]).por_mae(params[:mae_filter],params[:mae_filter]).paginate(page: params[:page], :per_page => 20)
    
    respond_to do |format|
      format.js 
    end
    
  end

  def show
    if @pombo == nil
      redirect_to root_url
      flash[:danger] = t :msg_erro_pombo_nao_encontrado
    end
  end
  
  def new
    @pombo = Pombo.new
  end

  def edit
  end

  def create
    @pombo = Pombo.new(pombo_params)
    @pombo.cor_id = COR_NAO_INFORMADA if @pombo.cor_id.blank?
    @pombo.usuario = current_user
    
    p = Pombo.por_usuario(current_user.id).por_anilha(@pombo.anilha)
    if p.count > 0
      flash[:danger] = t(:msg_erro_anilha_cadastrada)
      render :new 
    else
      if @pombo.save
        redirect_to @pombo
        flash[:success] = t(:label_pombo) + " " + t(:msg_info_criado_com_sucesso)
      else
        render :new 
      end
    end
  end

  def update
    
    if @pombo.update(pombo_params)
      redirect_to @pombo
      flash[:success] = t(:label_pombo) + " " + t(:msg_info_atualizado_com_sucesso)
    else
      render :edit
    end
    
  end

  def destroy
    @pombo.destroy
    redirect_to pombos_url
    flash[:success] = t(:label_pombo) + " " + t(:msg_info_excluido_com_sucesso)
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_pombo
      @pombo = Pombo.find_by_id(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def pombo_params
      params.require(:pombo).permit(:anilha, :nome, :dtnasc, :sexo, :desc_cor, :linhagem, :usuario_id, :pai_id, :mae_id, :vivo)
    end
    
    def parente_params(tipo)
      params.require(tipo).permit(:anilha, :nome, :dtnasc, :sexo, :desc_cor, :linhagem, :vivo, :pai_id, :mae_id)
    end
    
    def titulo_params
      params.require(:titulo).permit(:nome, :ano, :pombo_id)
    end
    
    def correct_user
      @pombo = current_user.pombos.find_by(id: params[:id])
      if @pombo.nil?
        flash[:danger] = t(:msg_erro_acao_nao_permitida)
        redirect_to usuario_path(current_user)
      end
    end
    
    def bloquear_vencto
      usr = current_user
      msg =  bloqueio(usr, BLOQUEIO_PAGTO)
      if msg != ''
        flash[:danger] = t msg
        redirect_to detalhar_assinatura_usuario_path(usr)
      end
    end
    
    def bloquear_limite
      usr = current_user
      msg =  bloqueio(usr, BLOQUEIO_LIMITE_QTD)
      if msg != ''
        flash[:danger] = t(msg, go: view_context.link_to(t(:msg_erro_rever_assinatura), detalhar_assinatura_usuario_path(usr))).html_safe
        redirect_to pombos_url
      end
    end
end
