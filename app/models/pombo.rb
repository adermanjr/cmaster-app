class Pombo < ApplicationRecord
  
  belongs_to :cor
  belongs_to :usuario
  has_and_belongs_to_many :pombals
  has_and_belongs_to_many :equipes
  
  has_many :aplicacaos
  has_many :tratamentos, through: :aplicacaos
  
  has_many :titulos
  
  has_many :resultados
  has_many :provas, through: :resultados
  
  before_validation   :pai_eh_macho, :mae_eh_femea
  before_save :ajuste_strings
  
  validates :anilha, length: { maximum: 10 }
  validates :nome,   presence: false, length: { maximum: 50 }
  validates :dtnasc, presence: false
  
  #validates :sexo,   presence: true, format: { 
  #     with: /^(F|M)$/ ,
  #     message: 'precisa ser F/M',
  #     multiline: true
  # }
  
  scope :por_anilha, ->(par) { where("anilha = ?", par.upcase) if par.present? }
  scope :por_sexo, ->(par) { where("sexo = ?", par.upcase) if par.present? }
  scope :por_pai, ->(nome_par, anilha_par) { where("pai_id = (select p2.id from pombos p2 where pombos.usuario_id = p2.usuario_id and (p2.nome LIKE ? or p2.anilha LIKE ?))", nome_par.capitalize + '%', anilha_par.upcase + '%') if nome_par.present? }
  scope :por_mae, ->(nome_par, anilha_par) { where("mae_id = (select p2.id from pombos p2 where pombos.usuario_id = p2.usuario_id and (p2.nome LIKE ? or p2.anilha LIKE ?))", nome_par.capitalize + '%', anilha_par.upcase + '%') if nome_par.present? }
  scope :esta_vivo, ->(par) { where("vivo = ?", par) if par.present? }
  scope :por_usuario, ->(par) {where("usuario_id = ?", par) if par.present? }
  scope :anilha_like, ->(par) { where("anilha LIKE ?", "%#{par.upcase}%") if par.present? }
  scope :em_tratamento, ->(p, t) { where(" exists ( select 1 from pombal_tratamentos pt, aplicacaos a where a.pombo_id = pombos.id and pt.id = a.pt_id and pt.pombal_id = ? and pt.tratamento_id = ?)", p, t) if p.present? }
  scope :por_equipe, ->(par) { where(" exists ( select 1 from equipes_pombos ep where ep.pombo_id = pombos.id and ep.equipe_id = ? )", par) if par.present? }
  scope :sem_resultado, ->(par) { where(" not exists (select 1 from resultados r where r.pombo_id = pombos.id and r.prova_id = ? )", par) if par.present? }
  
  #validates_with SexoValidator
  
  def pai
    if self.pai_id != nil
      begin
        Pombo.find(self.pai_id)
      rescue ActiveRecord::RecordNotFound 
        nil
      end
    else
      nil
    end
  end
  
  def mae
    if self.mae_id != nil
      begin
        Pombo.find(self.mae_id)
      rescue ActiveRecord::RecordNotFound
        nil
      end
    else
      nil
    end
  end
  
  def avo_paterno(sexo_par)
    pombo_pai = self.pai
    if pombo_pai != nil
      if sexo_par == 'M'
        pombo_pai.pai
      else
        pombo_pai.mae
      end
    else
      nil
    end
  end
  
  def avo_materno(sexo_par)
    pombo_mae = self.mae
    if pombo_mae != nil
      if sexo_par == 'M'
        pombo_mae.pai
      else
        pombo_mae.mae
      end
    else
      nil
    end
  end
  
  def bisavo_paterno(sexo_par, sexo_par2)
    avo_pat = self.avo_paterno(sexo_par)
    if avo_pat != nil
      if sexo_par2 == 'M'
        avo_pat.pai
      else
        avo_pat.mae
      end
    else
      nil
    end
  end
  
  def bisavo_materno(sexo_par, sexo_par2)
    avo_mat = self.avo_materno(sexo_par)
    if avo_mat != nil
      if sexo_par2 == 'M'
        avo_mat.pai
      else
        avo_mat.mae
      end
    else
      nil
    end
  end
  
  def pai_eh_macho
    if self.pai_id != nil
      if self.pai.sexo != 'M'
        self.errors.add(:pai_id, "cannot be female")
      end
    end
  end

  def mae_eh_femea
    if self.mae_id != nil
      if self.mae.sexo != 'F'
        self.errors.add(:mae_id, "cannot be male")
      end
    end
  end
  
  def ajuste_strings
    if self.nome != nil
      self.nome.capitalize!
    end
    
    if self.anilha != nil
      self.anilha.upcase!
    end
    
  end

end
