class CreatePreparos < ActiveRecord::Migration[5.2]
  def change
    create_table :preparos do |t|
      t.string :nome
      t.string :descricao
      t.integer :tipo_prova
      t.references :usuario, foreign_key: true

      t.timestamps
    end
  end
end
