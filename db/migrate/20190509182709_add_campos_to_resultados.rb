class AddCamposToResultados < ActiveRecord::Migration[5.2]
  def change
    add_column :resultados, :dist_oficial, :float
    add_column :resultados, :veloc_oficial, :float
  end
end
