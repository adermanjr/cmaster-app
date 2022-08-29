class AddPblIdToAplicacaos < ActiveRecord::Migration[5.0]
  def change
    add_column :aplicacaos, :pbl_id, :integer
  end
end
