class Equipe < ApplicationRecord
  belongs_to :usuario
  
  has_and_belongs_to_many :pombos
  
  scope :por_usuario, ->(par) {where("usuario_id = ?", par) if par.present? }
  
end
