class Competicao < ApplicationRecord
  
  has_many :provas
  belongs_to :usuario
  
  validates :nome,   presence: true, length: { maximum: 200 }
  validates :ano,    presence: true
  
  scope :por_estado,  ->(par) {where("est_id = ?", par) if par.present? }
  scope :por_clube,  ->(par) {where("clb_id = ?", par) if par.present? }
  
end
