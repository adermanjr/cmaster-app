class CreatePombals < ActiveRecord::Migration[5.0]
  def change
    create_table :pombals do |t|
      t.string :nome
      t.datetime :dtdesativ
      t.references :usuario, foreign_key: true

      t.timestamps
    end
    
  end
end
