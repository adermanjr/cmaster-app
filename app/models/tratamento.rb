class Tratamento < ApplicationRecord
  belongs_to :usuario
  
  has_many :aplicacaos
  has_many :pombos, through: :aplicacaos
  
  has_many :pombal_tratamentos
  has_many :pombals, through: :pombal_tratamentos
  
  validates :nome,   presence: true, length: { maximum: 100 }
  validates :indicacao,   length: { maximum: 200 }
  
  scope :por_usuario, ->(par) {where("usuario_id = ?", par) if par.present? }
  
end
