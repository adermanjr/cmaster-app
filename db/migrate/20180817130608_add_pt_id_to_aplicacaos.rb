class AddPtIdToAplicacaos < ActiveRecord::Migration[5.0]
  def change
    add_column :aplicacaos, :pt_id, :integer
  end
end
