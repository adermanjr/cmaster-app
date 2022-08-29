class RemovePblIdFromAplicacaos < ActiveRecord::Migration[5.0]
  def change
    remove_column :aplicacaos, :pbl_id, :integer
  end
end
