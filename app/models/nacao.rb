class Nacao < ApplicationRecord
  has_many :estados
  
  scope :por_locale, ->(par) { where("locale = ?", par) if par.present? }
end
