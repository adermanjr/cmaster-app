class CreateTitulos < ActiveRecord::Migration[5.0]
  def change
    create_table :titulos do |t|
      t.string :nome
      t.integer :ano

      t.belongs_to :pombo, index: true
      
      t.timestamps
    end
  end
end
