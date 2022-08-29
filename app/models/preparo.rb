class Preparo < ApplicationRecord
  belongs_to :usuario
  
  has_many :prova_preparos
  has_many :provas, through: :prova_preparos
  
  scope :por_usuario, ->(par) {where("usuario_id = ?", par) if par.present? }
  
end
