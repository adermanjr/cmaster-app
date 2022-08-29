class RemoveCidadeEstIdDistanciaFromProvas < ActiveRecord::Migration[5.2]
  def change
    remove_column :provas, :cidade, :string
    remove_column :provas, :est_id, :integer
    remove_column :provas, :distancia, :integer
  end
end
