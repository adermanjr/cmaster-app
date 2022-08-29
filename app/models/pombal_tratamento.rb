class PombalTratamento < ApplicationRecord
  
  belongs_to :pombal
  belongs_to :tratamento
  
  validates :dtinicio, presence: true
  
end
