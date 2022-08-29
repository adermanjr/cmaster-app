class ClubesController < ApplicationController
  before_action :set_clube, only: [:show, :edit, :update, :destroy]
  before_action :logged_in_user, only: [:new, :create, :edit, :update, :destroy, :show]
  before_action :correct_user,   only: [:edit, :update, :show, :destroy]

  # GET /clubes
  def index
    @clubes = Clube.all
  end

  # GET /clubes/1
  def show
  end

  # GET /clubes/new
  def new
    @clube = Clube.new
  end

  # GET /clubes/1/edit
  def edit
  end

  # POST /clubes
  def create
    @clube = Clube.new(clube_params)

    if @clube.save
      redirect_to clubes_path
      flash[:success] = t(:label_clube) + " " + t(:msg_info_criado_com_sucesso)
    else
      render :new
    end
  end

  # PATCH/PUT /clubes/1
  def update
    if @clube.update(clube_params)
      redirect_to @clube
      flash[:success] = t(:label_clube) + " " + t(:msg_info_atualizado_com_sucesso)
    else
      render :edit
    end
  end

  # DELETE /clubes/1
  def destroy
    @clube.destroy
    redirect_to clubes_url
    flash[:success] = t(:label_clube) + " " + t(:msg_info_excluido_com_sucesso)
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_clube
      @clube = Clube.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def clube_params
      params.require(:clube).permit(:nome, :idregistro, :email, :logradouro, :complemento, :bairro, :cep, :tel1, :tel2, :contato, :cidade, :estado_id, :nacao_id)
    end
    
    def correct_user
      
      if current_user.tipo_usuario != USUARIO_MODERADOR && !current_user.admin
        flash[:danger] = t(:msg_erro_acao_nao_permitida)
        redirect_to usuario_path(current_user)
      end
    end
end
