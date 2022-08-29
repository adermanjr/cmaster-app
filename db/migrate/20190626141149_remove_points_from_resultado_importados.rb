class RemovePointsFromResultadoImportados < ActiveRecord::Migration[5.2]
  def change
    remove_column :resultado_importados, :points, :integer
  end
end
