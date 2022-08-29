class AddUsuarioToProvas < ActiveRecord::Migration[5.0]
  def change
    add_reference :provas, :usuario, foreign_key: true
    add_reference :resultados, :usuario, foreign_key: true
  end
end
