class CreateTratamentos < ActiveRecord::Migration[5.0]
  def change
    create_table :tratamentos do |t|
      t.string :nome
      t.string :indicacao
      
      t.references :usuario, foreign_key: true

      t.timestamps
    end
    
    create_table :aplicacaos do |t|
      t.belongs_to :tratamento, index: true
      t.belongs_to :pombo, index: true
      t.datetime :dtaplicacao
      t.float :dosagem
      t.string :medida
      t.timestamps
    end
    
    create_table :pombal_tratamentos do |t|
      t.belongs_to :pombal, index: true
      t.belongs_to :tratamento, index: true
      
      t.datetime :dtinicio
      t.datetime :dtfim
      
      t.boolean :lembrar
      t.integer :qtde
      t.string :intervalo
      
      t.timestamps
    end
    
  end
end
#http://guides.rubyonrails.org/association_basics.html#the-has-many-through-association