class CreateProvas < ActiveRecord::Migration[5.0]
  def change
    create_table :provas do |t|
      t.string :nome
      t.datetime :dtsolta
      t.string :cidade
      t.integer :est_id
      t.integer :distancia
      t.integer :tipo

      t.timestamps
      
      t.references :competicao, foreign_key: true
      
    end
    
    create_table :resultados do |t|
      t.belongs_to :prova, index: true
      t.belongs_to :pombo, index: true
      t.datetime :dhrestimada
      t.datetime :dhroficial
      t.integer :posicao
      t.float :pontos
      
      t.timestamps
    end
    
  end
end
