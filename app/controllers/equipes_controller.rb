class EquipesController < ApplicationController
  before_action :set_equipe, only: [:show, :edit, :update, :destroy, :show_modal, :assoc_pombo, :desassoc_pombo]
  before_action :logged_in_user, only: [:new, :create, :edit, :update, :destroy, :show]
  before_action :correct_user,   only: [:edit, :update, :show, :destroy]
  before_action :bloquear
  
  def show_modal
    @pombo = Pombo.new
    
    respond_to do |format|
      format.js 
    end
  end
  
  def assoc_pombo
    @ok = true
    pombos = Pombo.por_anilha(params["pombo"]["anilha"]).por_usuario(current_user)
    if pombos.count > 0
      @pombo = pombos.first
      if @pombo.equipes.any?
        @ok = false
        tipo_alerta = 'danger'
       msg = t :msg_info_presente_time
      else
        @equipe.pombos << @pombo
        tipo_alerta = 'success'
        msg = "#{t :label_pombo} #{t :msg_info_adiciado_com_sucesso}"
      end
    else
      @ok = false
      tipo_alerta = 'danger'
      msg = t :msg_erro_anilha_nao_encontrada
    end
    
    respond_to do |format|
      format.js { flash.now[tipo_alerta] =  msg}
    end
  end
  
  def desassoc_pombo
    pombo = Pombo.find(params["pombo_id"])
    @equipe.pombos.delete(pombo)
    @tela = params['tela']
    
    respond_to do |format|
      format.js { flash.now[:success] = t(:label_pombo) + " " + t(:msg_info_removido_com_sucesso) }
    end
  end

  def index
    @equipes = Equipe.por_usuario(current_user)
    if @equipes.count == 0
      redirect_to new_equipe_url
    end
  end

  def show
  end

  def new
    @equipe = Equipe.new
  end

  def edit
  end

  def create
    @equipe = Equipe.new(equipe_params)
    @equipe.usuario = current_user
    
    if @equipe.save
      redirect_to equipes_path
      flash[:success] = t(:label_time) + " " + t(:msg_info_criado_com_sucesso)
    else
      render :new
    end
  end

  def update
    if @equipe.update(equipe_params)
      redirect_to @equipe
      flash[:success] = t(:label_time) + " " + t(:msg_info_atualizado_com_sucesso)
    else
      render :edit
    end
  end

  def destroy
    @equipe.pombos.delete_all
    @equipe.destroy
    redirect_to equipes_url
    flash[:success] = t(:label_time) + " " + t(:msg_info_excluido_com_sucesso)
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_equipe
      @equipe = Equipe.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def equipe_params
      params.require(:equipe).permit(:nome)
    end
    
    def correct_user
      @equipe = current_user.equipes.find_by(id: params[:id])
      if @equipe.nil?
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
