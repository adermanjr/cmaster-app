class CreateProvaPreparos < ActiveRecord::Migration[5.2]
  def change
    create_table :prova_preparos do |t|
      t.references :prova, foreign_key: true
      t.references :preparo, foreign_key: true
      t.references :usuario, foreign_key: true
      t.timestamps
    end
  end
end
