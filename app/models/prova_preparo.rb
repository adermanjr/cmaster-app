class ProvaPreparo < ApplicationRecord
  belongs_to :prova
  belongs_to :preparo 
  belongs_to :usuario
  
end
