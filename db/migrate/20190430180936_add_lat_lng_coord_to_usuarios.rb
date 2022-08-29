class AddLatLngCoordToUsuarios < ActiveRecord::Migration[5.2]
  def change
    add_column :usuarios, :lat_card, :string
    add_column :usuarios, :lat_deg, :float
    add_column :usuarios, :lat_min, :float
    add_column :usuarios, :lat_seg, :float
    add_column :usuarios, :lng_card, :string
    add_column :usuarios, :lng_deg, :float
    add_column :usuarios, :lng_min, :float
    add_column :usuarios, :lng_seg, :float
    add_column :usuarios, :logradouro, :string
  end
end
