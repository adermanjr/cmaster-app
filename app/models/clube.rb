class Clube < ApplicationRecord
  belongs_to :estado
    
  scope :por_estado, ->(par) {where("estado_id = ?", par) if par.present? }
  
end
