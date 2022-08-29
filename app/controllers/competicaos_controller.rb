class CompeticaosController < ApplicationController
  before_action :set_competicao, only: [:show, :edit, :update, :destroy, :esquadrao, :esquadrao_order]
  before_action :logged_in_user, only: [:new, :create, :edit, :update, :destroy, :show]
  before_action :bloquear

  def atualiza_combo_clube
    @clubes = Clube.por_estado(params[:estado_id]).order(:nome)
    respond_to do |format|
      format.js
    end
  end
  
  def modal_result
    if params[:pombo_id]
      @pombo = Pombo.find params[:pombo_id]
      @prova = nil
    else
      @prova = Prova.find params[:prova_id]
      @pombo = nil
    end
    @competicao = Competicao.find params[:competicao_id]
    
    if @pombo
      @resultados_pombo = query_resultado_por_pombo(params[:competicao_id].to_i, params[:usuario_id].to_i, @pombo.id)
    else
      @resultados_pombo = query_resultado_por_prova(params[:competicao_id].to_i, params[:usuario_id].to_i, @prova.id)
    end
    respond_to do |format|
      format.js
    end
  end
  
  def esquadrao
    begin
      @usuario = Usuario.find params[:usr]
    rescue ActiveRecord::RecordNotFound 
      flash[:danger] = t :msg_erro_link_invalido
      return
    end
    
    @ordem = 'MODALIDADE'
    @campeoes_veloc = query_campeoes(@competicao.id, @usuario.id, VELOCIDADE)
    @campeoes_meio = query_campeoes(@competicao.id, @usuario.id, MEIO_FUNDO)
    @campeoes_fundo = query_campeoes(@competicao.id, @usuario.id, FUNDO)
    
  end
  
  def esquadrao_order
    
    begin
      @usuario = Usuario.find params[:usr]
    rescue ActiveRecord::RecordNotFound 
      flash[:danger] = t :msg_erro_link_invalido
      return
    end
    
    @ordem = params[:ordem]
    
    if @ordem == 'GERAL'
      @campeoes = query_campeoes_geral(@competicao.id, @usuario.id)
    elsif @ordem == 'REGULARIDADE'
      @campeoes = query_resultado_por_regularidade(@competicao.id, @usuario.id)
    else
      @campeoes_veloc = query_campeoes(@competicao.id, @usuario.id, VELOCIDADE)
      @campeoes_meio = query_campeoes(@competicao.id, @usuario.id, MEIO_FUNDO)
      @campeoes_fundo = query_campeoes(@competicao.id, @usuario.id, FUNDO)
    end
    respond_to do |format|
      format.js
    end
  end

  # GET /competicaos
  def index
    @competicaos = Competicao.all.order(ano: :desc)
  end

  # GET /competicaos/1
  def show
  end

  # GET /competicaos/new
  def new
    @competicao = Competicao.new
  end

  # GET /competicaos/1/edit
  def edit
  end

  # POST /competicaos
  def create
    @competicao = Competicao.new(competicao_params)
    @competicao.usuario = current_user
    if @competicao.save
      redirect_to competicaos_path
      flash[:success] = t(:label_competicao) + " " + t(:msg_info_criado_com_sucesso)
    else
      render :new
    end
  end

  # PATCH/PUT /competicaos/1
  def update
    if @competicao.update(competicao_params)
      redirect_to @competicao
      flash[:success] = t(:label_competicao) + " " + t(:msg_info_atualizado_com_sucesso)
    else
      render :edit
    end
  end

  # DELETE /competicaos/1
  def destroy
    @competicao.destroy
    redirect_to competicaos_url
    flash[:success] = t(:label_competicao) + " " + t(:msg_info_excluido_com_sucesso) 
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_competicao
      @competicao = Competicao.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def competicao_params
      params.require(:competicao).permit(:nome, :ano, :clb_id, :est_id)
    end
    
    def bloquear
      usr = current_user
      msg =  bloqueio(usr, BLOQUEIO_PAGTO)
      if msg != ''
        flash[:danger] = t msg
        redirect_to detalhar_assinatura_usuario_path(usr)
      end
    end
    
    def query_campeoes(competicao_id, usuario_id, tipo_prova)
      sql = <<-SQL
         SELECT p.id as pombo_id, p.anilha, v.tipo, sum(r.pontos) as soma_pontos, avg(r.veloc_oficial) as media_veloc, sum(r.dist_oficial) as total_km, count(p.anilha) as qtde
           FROM pombos p, resultados r, provas v 
          WHERE p.usuario_id = r.usuario_id
            AND p.id = r.pombo_id
            AND v.id = r.prova_id
            AND r.usuario_id = ?
            AND v.competicao_id = ?
            AND v.tipo = ?
            AND r.pontos is not null
          GROUP BY p.id, p.anilha, v.tipo
          ORDER BY 4 DESC
          LIMIT 25
           
      SQL
      
      ActiveRecord::Base.connection.select_all(ActiveRecord::Base.send("sanitize_sql_array",[sql, usuario_id, competicao_id, tipo_prova] ) )
    end
    
    def query_resultado_por_pombo(competicao_id, usuario_id, pombo_id)
      sql = <<-SQL
         SELECT p.id as pombo_id, p.anilha, v.nome, v.tipo, v.dtsolta, r.pontos, r.veloc_oficial, r.dist_oficial, r.dhroficial, r.posicao, r.pontos, u.fuso, r.prova_id
           FROM pombos p, resultados r, provas v, usuarios u
          WHERE p.usuario_id = r.usuario_id
            AND p.id = r.pombo_id
            AND v.id = r.prova_id
            AND u.id = r.usuario_id
            AND r.usuario_id = ?
            AND v.competicao_id = ?
            AND p.id = ?
            AND r.pontos is not null
          ORDER BY r.pontos desc
           
      SQL
      
      ActiveRecord::Base.connection.select_all(ActiveRecord::Base.send("sanitize_sql_array",[sql, usuario_id, competicao_id, pombo_id] ) )
    end
    
    def query_resultado_por_prova(competicao_id, usuario_id, prova_id)
      sql = <<-SQL
         SELECT p.id as pombo_id, p.anilha, v.nome, v.tipo, v.dtsolta, r.pontos, r.veloc_oficial, r.dist_oficial, r.dhroficial, r.posicao, r.pontos, u.fuso, r.prova_id
           FROM pombos p, resultados r, provas v, usuarios u
          WHERE p.usuario_id = r.usuario_id
            AND p.id = r.pombo_id
            AND v.id = r.prova_id
            AND u.id = r.usuario_id
            AND r.usuario_id = ?
            AND v.competicao_id = ?
            AND v.id = ?
            AND r.pontos is not null
          ORDER BY r.pontos desc
           
      SQL
      
      ActiveRecord::Base.connection.select_all(ActiveRecord::Base.send("sanitize_sql_array",[sql, usuario_id, competicao_id, prova_id] ) )
    end
    
    def query_campeoes_geral(competicao_id, usuario_id)
      sql = <<-SQL
         SELECT p.id as pombo_id, p.anilha, sum(r.pontos) as soma_pontos, avg(r.veloc_oficial) as media_veloc, sum(r.dist_oficial) as total_km, count(p.anilha) as qtde
           FROM pombos p, resultados r, provas v 
          WHERE p.usuario_id = r.usuario_id
            AND p.id = r.pombo_id
            AND v.id = r.prova_id
            AND r.usuario_id = ?
            AND v.competicao_id = ?
            AND r.pontos is not null
          GROUP BY p.id, p.anilha
          ORDER BY 3 DESC
          LIMIT 25
           
      SQL
      
      ActiveRecord::Base.connection.select_all(ActiveRecord::Base.send("sanitize_sql_array",[sql, usuario_id, competicao_id] ) )
    end
    
    def query_resultado_por_regularidade(competicao_id, usuario_id)
      sql = <<-SQL
         SELECT v.id as prova_id, v.nome, v.tipo, v.dtsolta, u.fuso, count(r.id) as qtde, sum(r.pontos) as soma_pontos
           FROM pombos p, resultados r, provas v, usuarios u
          WHERE p.usuario_id = r.usuario_id
            AND p.id = r.pombo_id
            AND v.id = r.prova_id
            AND u.id = r.usuario_id
            AND r.usuario_id = ?
            AND v.competicao_id = ?
            AND r.pontos is not null
          GROUP BY v.id, v.nome, v.tipo, v.dtsolta, u.fuso
          ORDER BY 6 desc
           
      SQL
      
      ActiveRecord::Base.connection.select_all(ActiveRecord::Base.send("sanitize_sql_array",[sql, usuario_id, competicao_id] ) )
    end
end
