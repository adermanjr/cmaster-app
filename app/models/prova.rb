class Prova < ApplicationRecord
  belongs_to :competicao
  belongs_to :usuario
  
  has_many :resultados
  has_many :pombos, through: :resultados
  
  has_many :prova_preparos
  has_many :preparos, through: :prova_preparos
  
  scope :por_usuario, ->(u) { where(" exists ( select 1 from resultados r , pombos p where r.prova_id = provas.id and p.id = r.pombo_id and p.usuario_id = ?)", u) if u.present? }
end
