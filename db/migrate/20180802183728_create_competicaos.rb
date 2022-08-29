class CreateCompeticaos < ActiveRecord::Migration[5.0]
  def change
    create_table :competicaos do |t|
      t.string :nome
      t.integer :ano
      
      t.integer :clb_id
      t.integer :est_id
      
      t.references :usuario, foreign_key: true

      t.timestamps
    end
    
  end
end
