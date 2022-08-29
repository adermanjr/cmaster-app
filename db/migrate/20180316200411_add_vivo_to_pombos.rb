class AddVivoToPombos < ActiveRecord::Migration[5.0]
  def change
    add_column :pombos, :vivo, :boolean, default: true
  end
end
