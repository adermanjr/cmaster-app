class PombalsController < ApplicationController
  before_action :set_pombal, only: [:show, :edit, :update, :destroy]
  before_action :logged_in_user, only: [:new, :create, :edit, :update, :destroy, :show]
  before_action :correct_user,   only: [:edit, :update, :show, :destroy]
  before_action :bloquear

  def show_modal_aplicacao
    @objeto = Pombal.find(params[:id])
    @tipo = 'B'
    respond_to do |format|
      format.js
    end
  end
  
  def gerar_aplicacao
    @msgs = Array.new
    if valida_aplicacao(params[:tratamento_id], params[:dtini_par], params[:dtfim_par], params[:dosagem_par], params[:medida_par], params[:lembrar_par], params[:qtde_par], params[:intervalo_par])
      pt = PombalTratamento.new(pombal_id: params[:id], tratamento_id: params[:tratamento_id], 
                           dtinicio: params[:dtini_par], dtfim: params[:dtfim_par],
                           lembrar: params[:lembrar_par], qtde: params[:qtde_par], intervalo: params[:intervalo_par])
      if !pt.save
        respond_to do |format|
          format.js { flash.now[:danger] = pt.errors }
        end
      end
      
      qtdePombos = Pombal.find(params[:id]).pombos.esta_vivo('t').count
      Pombal.find(params[:id]).pombos.each do |pombo|
        if pombo.vivo
          aplicacao = Aplicacao.new(pombo_id: pombo.id, tratamento_id: params[:tratamento_id], dtaplicacao: params[:dtini_par], dosagem: (params[:dosagem_par].to_f/qtdePombos.to_f), medida: params[:medida_par], pt_id: pt.id)
          if !aplicacao.save
            respond_to do |format|
              format.js { flash.now[:danger] = aplicacao.errors }
            end
          end
        end
      end
      
      redirect_to pombals_path
      flash[:success] = t(:label_aplicacao) + " " + t(:msg_info_criado_com_sucesso)
    else
      respond_to do |format|
        format.js { flash.now[:danger] = @msgs }
      end
    end
  end
  
  def valida_aplicacao(tratamento, dtini, dtfim, dosagem, medida, lembrar, qtde, intervalo)
    ok = true
    if tratamento.blank? 
      @msgs << "#{t :label_tratamento} #{t('errors.messages.required')}"
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

  def index
    @pombals = Pombal.por_usuario(current_user.id)
  end

  def show
  end

  def new
    @pombal = Pombal.new
  end

  def edit
    
    sql = <<-SQL
     SELECT p.id as pombo_id, p.anilha, p.nome, p.sexo, (select pb.pombal_id from pombals_pombos pb where pb.pombal_id = ? and pb.pombo_id = p.id ) as pombal_id
       FROM pombos p 
      WHERE p.usuario_id = ?
        AND NOT EXISTS (select 1
                      from pombals pb
                         , pombals_pombos pp2
                     where pb.id = pp2.pombal_id
                       and pp2.pombo_id = p.id
                       and pp2.pombal_id <> ?
                       and pb.usuario_id = p.usuario_id
                       and (pb.dtdesativ is null or pb.dtdesativ > ?))
       ORDER BY 5 DESC, 3 ASC
       
  SQL
    @pombos = ActiveRecord::Base.connection.select_all(ActiveRecord::Base.send("sanitize_sql_array",[sql, @pombal.id, current_user.id, @pombal.id, Time.current] ) )
    
  end

  def create
    @pombal = Pombal.new(pombal_params)
    @pombal.usuario = current_user
    if @pombal.save
      redirect_to pombals_path
      flash[:success] = t(:label_pombal) + " " + t(:msg_info_criado_com_sucesso)
    else
      render :new
    end
  end

  def update
    if @pombal.update(pombal_params)
      
      @pombal.pombos.delete_all
      
      if params['pombo'] != nil
        params['pombo'].each do |k, v|
          if v == '1'
            @pombal.pombos << Pombo.find(k)
          end
        end
      end
      redirect_to @pombal
      flash[:success] = t(:label_pombal) + " " + t(:msg_info_atualizado_com_sucesso)
    else
      render :edit
    end
  end

  def destroy
    @pombal.pombos.delete_all
    @pombal.tratamentos.delete_all
    @pombal.destroy
    redirect_to pombals_url
    flash[:success] = t(:label_pombo) + " " + t(:msg_info_excluido_com_sucesso)
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_pombal
      @pombal = Pombal.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def pombal_params
      params.require(:pombal).permit(:nome, :dtdesativ)
    end
    
    def correct_user
      @pombal = current_user.pombals.find_by(id: params[:id])
      if @pombal.nil?
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
