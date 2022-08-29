class Pombal < ApplicationRecord
  
  has_and_belongs_to_many :pombos
  belongs_to :usuario
  
  has_many :pombal_tratamentos
  has_many :tratamentos, through: :pombal_tratamentos
  
  validates :nome,   presence: true, length: { maximum: 50 }
  
  scope :por_usuario, ->(par) {where("usuario_id = ?", par) if par.present? }
  scope :ativo,            -> { where("dtdesativ is null") }
  
end
