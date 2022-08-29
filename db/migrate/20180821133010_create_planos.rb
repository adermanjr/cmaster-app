class CreatePlanos < ActiveRecord::Migration[5.0]
  def change
    create_table :planos do |t|
      t.string :tipo
      t.datetime :dtinicio_pagto
      t.datetime :dtcancelamento
      t.float :valor_mensal
      t.string :moeda
      t.string :id_recorrencia_operadora
      t.string :url_recorrencia_operadora

      t.references :usuario, foreign_key: true
      
      t.timestamps
    end
  end
end
