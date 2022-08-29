class CreateEquipes < ActiveRecord::Migration[5.0]
  def change
    create_table :equipes do |t|
      t.string :nome

      t.timestamps
      
      t.references :usuario, foreign_key: true
    end
    
    create_table :equipes_pombos, id: false do |t|
      t.references :equipe, foreign_key: true
      t.references :pombo, foreign_key: true
    end
  end
end
