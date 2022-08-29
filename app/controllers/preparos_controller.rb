class PreparosController < ApplicationController
  before_action :set_preparo, only: [:show, :edit, :update, :destroy]
  before_action :logged_in_user, only: [:new, :create, :edit, :update, :destroy, :show]
  before_action :correct_user,   only: [:edit, :update, :show, :destroy]
  before_action :bloquear
  
  def index
    @preparos = Preparo.por_usuario(current_user)
    if @preparos.count == 0
      redirect_to new_preparo_url
    end
  end

  def show
  end

  # GET /preparos/new
  def new
    @preparo = Preparo.new
  end

  # GET /preparos/1/edit
  def edit
  end
  
  # POST /preparos
  def create
    @preparo = Preparo.new(preparo_params)
    @preparo.usuario = current_user

    if @preparo.save
      redirect_to preparos_path
      flash[:success] = "#{t :label_preparo} #{t :msg_info_criado_com_sucesso}"
    else
      render :new
    end
  end

  # PATCH/PUT /preparos/1
  def update
    if @preparo.update(preparo_params)
      redirect_to @preparo
      flash[:success] = "#{t :label_preparo} #{t :msg_info_atualizado_com_sucesso}"
    else
      render :edit
    end
  end

  # DELETE /preparos/1
  def destroy
    @preparo.provas.delete_all
    @preparo.destroy
    redirect_to preparos_url
    flash[:success] = "#{t :label_preparo} #{t :msg_info_excluido_com_sucesso}"
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_preparo
      @preparo = Preparo.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def preparo_params
      params.require(:preparo).permit(:nome, :descricao, :tipo_prova)
    end
    
    def correct_user
      @preparo = Preparo.find_by(id: params[:id], usuario_id: current_user) 
      if @preparo.nil?
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
