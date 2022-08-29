class CreateNacaos < ActiveRecord::Migration[5.0]
  def change
    create_table :nacaos do |t|
      t.string :nome
      t.string :sigla

      t.timestamps
    end
  end
end
