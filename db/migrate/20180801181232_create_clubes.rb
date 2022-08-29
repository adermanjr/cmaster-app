class CreateClubes < ActiveRecord::Migration[5.0]
  def change
    create_table :clubes do |t|
      t.string :nome
      t.string :idregistro
      t.string :email
      t.string :logradouro
      t.string :complemento
      t.string :bairro
      t.integer :cep
      t.string :tel1
      t.string :tel2
      t.string :contato
      
      t.references :estado, foreign_key: true

      t.timestamps
    end
  end
end
