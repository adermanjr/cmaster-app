class CreatePombalsPombo < ActiveRecord::Migration[5.0]
  def change
    create_table :pombals_pombos, id: false do |t|
      t.references :pombal, foreign_key: true
      t.references :pombo, foreign_key: true
    end
  end
end