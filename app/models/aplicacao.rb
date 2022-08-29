class Aplicacao < ApplicationRecord
  belongs_to :pombo
  belongs_to :tratamento
  
  validates :dtaplicacao, presence: true
  
  scope :por_pombal_tratamento, ->(par) { where("pt_id = ?", par) if par.present? }
  scope :por_tratamento, ->(par) { where("tratamento_id = ?", par) if par.present? }
  scope :pombos_pombal_tratamento, ->(p, t) { where(" exists ( select 1 from pombal_tratamentos pt, pombos p where aplicacaos.pombo_id = p.id and pt.id = aplicacaos.pt_id and pt.id = ? and pt.tratamento_id = ?)", p, t) if p.present? }
  
end
