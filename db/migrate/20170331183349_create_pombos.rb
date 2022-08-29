class CreatePombos < ActiveRecord::Migration[5.0]
  def change
    create_table :pombos do |t|
      t.string :anilha
      t.string :nome
      t.datetime :dtnasc
      t.string :sexo
      t.references :cor, foreign_key: true
      t.references :usuario, foreign_key: true

      t.timestamps
    end
  end
end
