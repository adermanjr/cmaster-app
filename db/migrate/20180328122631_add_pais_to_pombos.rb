class AddPaisToPombos < ActiveRecord::Migration[5.0]
  def change
    add_column :pombos, :pai_id, :integer
    add_column :pombos, :mae_id, :integer
    
    add_index :pombos, [:id, :pai_id], unique: true
    add_index :pombos, [:id, :mae_id], unique: true
  end
end
