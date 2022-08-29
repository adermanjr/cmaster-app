class AddLatLngCoordToProvas < ActiveRecord::Migration[5.2]
  def change
    add_column :provas, :lat_card, :string
    add_column :provas, :lat_deg, :float
    add_column :provas, :lat_min, :float
    add_column :provas, :lat_seg, :float
    add_column :provas, :lng_card, :string
    add_column :provas, :lng_deg, :float
    add_column :provas, :lng_min, :float
    add_column :provas, :lng_seg, :float
  end
end
