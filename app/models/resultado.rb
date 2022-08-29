class Resultado < ApplicationRecord
  belongs_to :pombo
  belongs_to :prova
  belongs_to :usuario
  
  scope :por_prova, ->(par) {where("prova_id = ?", par) if par.present? }
  scope :por_anilha, ->(par) {where("exists ( select 1 from pombos p where p.id = resultados.pombo_id and p.anilha like ? )", "%#{par}%") if par.present? }
  scope :por_pombo, ->(par) {where("pombo_id = ?", par) if par.present? }
  scope :oficial, -> {where("pontos > 0 ")}
  scope :parcial, -> {where("dhrestimada is not null")}
end