class Estado < ApplicationRecord
  belongs_to :nacao
  has_many :clubes
  
  scope :que_tem_clube, ->(par) { where(" exists (select 1 from Clubes c where c.estado_id = estados.id)") if par }
end
