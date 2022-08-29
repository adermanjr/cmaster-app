class TratamentosController < ApplicationController
  before_action :set_tratamento, only: [:show, :edit, :update, :destroy, :gerar_aplicacao]
  before_action :logged_in_user, only: [:new, :create, :edit, :update, :destroy, :show, :gerar_aplicacao]
  before_action :correct_user,   only: [:edit, :update, :show, :destroy]
  before_action :bloquear
  
  def show_modal
    params.inspect
    @pt = PombalTratamento.find(params[:pt_id])
    @aps = Aplicacao.por_pombal_tratamento(params[:pt_id])
    respond_to do |format|
      format.js
    end
  end
  
  def destroy_pombal_tratamento
    pt = PombalTratamento.find(params[:pt_id])
    tratamento = pt.tratamento
    Aplicacao.por_pombal_tratamento(pt.id).each do |apl|
      apl.destroy
    end
    pt.destroy
    
    redirect_to tratamento
    flash[:success] = t(:label_aplicacao) + " " + t(:msg_info_excluido_com_sucesso)
  end

  def show_modal_aplicacao
    @objeto = Tratamento.find(params[:id])
    @tipo = 'T'
    respond_to do |format|
      format.js
    end
  end
  
  def gerar_aplicacao
    @msgs = Array.new
    if valida_aplicacao(params[:pombal_id], params[:dtini_par], params[:dtfim_par], params[:dosagem_par], params[:medida_par], params[:lembrar_par], params[:qtde_par], params[:intervalo_par])
      pt = PombalTratamento.new(pombal_id: params[:pombal_id], tratamento_id: params[:id], 
                           dtinicio: params[:dtini_par], dtfim: params[:dtfim_par],
                           lembrar: params[:lembrar_par], qtde: params[:qtde_par], intervalo: params[:intervalo_par])
      if !pt.save
        respond_to do |format|
          format.js { flash.now[:danger] = pt.errors }
        end
      end
      
      qtdePombos = Pombal.find(params[:pombal_id]).pombos.esta_vivo('t').count
      
      Pombal.find(params[:pombal_id]).pombos.each do |pombo|
        if pombo.vivo
          aplicacao = Aplicacao.new(pombo_id: pombo.id, tratamento_id: params[:id], dtaplicacao: params[:dtini_par], dosagem: (params[:dosagem_par].to_f/qtdePombos.to_f), medida: params[:medida_par], pt_id: pt.id )
          if !aplicacao.save
            respond_to do |format|
              format.js { flash.now[:danger] = aplicacao.errors }
            end
          end
        end
      end
      
      redirect_to pt.tratamento
      flash[:success] = t(:label_aplicacao) + " " + t(:msg_info_criado_com_sucesso)
    else
      respond_to do |format|
        format.js { flash.now[:danger] = @msgs }
      end
    end
  end
  
  def valida_aplicacao(pombal, dtini, dtfim, dosagem, medida, lembrar, qtde, intervalo)
    ok = true
    if pombal.blank? 
      @msgs << "#{t :label_pombal} #{t('errors.messages.required')}"
      ok = false
    end
    if dtini.blank? 
      @msgs << "#{t :label_data_inicio} #{t('errors.messages.required')}"
      ok = false
    end
    
    if !dtini.blank? && !dtfim.blank? && dtini > dtfim
      @msgs << "#{t :label_data_fim} #{t('errors.messages.greater_than', count: t(:label_data_inicio))}"
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
    
    if !lembrar.blank? && lembrar
      if qtde.blank? 
        @msgs << "#{t :label_qtde} #{t('errors.messages.required')}"
        ok = false
      end
      
      if intervalo.blank? 
        @msgs << "#{t :label_intervalo} #{t('errors.messages.required')}"
        ok = false
      end
    end
    
    return ok
  end
  
  # GET /tratamentos
  def index
    @tratamentos = Tratamento.por_usuario(current_user.id)
  end

  # GET /tratamentos/1
  def show
  end

  # GET /tratamentos/new
  def new
    @tratamento = Tratamento.new
  end

  # GET /tratamentos/1/edit
  def edit
  end

  # POST /tratamentos
  def create
    @tratamento = Tratamento.new(tratamento_params)
    @tratamento.usuario = current_user
    if @tratamento.save
      redirect_to tratamentos_path
      flash[:success] = t(:label_tratamento) + " " + t(:msg_info_criado_com_sucesso)
    else
      render :new
    end
  end

  # PATCH/PUT /tratamentos/1
  def update
    if @tratamento.update(tratamento_params)
      redirect_to @tratamento
      flash[:success] = t(:label_tratamento) + " " + t(:msg_info_atualizado_com_sucesso)
    else
      render :edit
    end
  end

  # DELETE /tratamentos/1
  def destroy
    @tratamento.pombos.delete_all
    @tratamento.pombals.delete_all
    @tratamento.destroy
    redirect_to tratamentos_url
    flash[:success] = t(:label_tratamento) + " " + t(:msg_info_excluido_com_sucesso)
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_tratamento
      @tratamento = Tratamento.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def tratamento_params
      params.require(:tratamento).permit(:nome, :indicacao, :lembrar, :qtde, :intervalo)
    end
    
    def correct_user
      @tratamento = current_user.tratamentos.find_by(id: params[:id])
      if @tratamento.nil?
        flash[:danger] = t(:msg_erro_acao_nao_permitida)
        redirect_to usuario_path(current_user)
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
