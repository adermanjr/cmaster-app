class AddPointsToResultadoImportados < ActiveRecord::Migration[5.2]
  def change
    add_column :resultado_importados, :points, :float
  end
end
