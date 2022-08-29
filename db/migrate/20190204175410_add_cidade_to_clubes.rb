class AddCidadeToClubes < ActiveRecord::Migration[5.2]
  def change
    add_column :clubes, :cidade, :string
  end
end
