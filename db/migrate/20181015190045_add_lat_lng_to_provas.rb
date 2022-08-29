class AddLatLngToProvas < ActiveRecord::Migration[5.0]
  def change
    add_column :provas, :lat, :string
    add_column :provas, :lng, :string
  end
end
