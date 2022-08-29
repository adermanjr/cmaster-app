class AddLinhagemDescCorToPombos < ActiveRecord::Migration[5.2]
  def change
    add_column :pombos, :linhagem, :string
    add_column :pombos, :desc_cor, :string
  end
end
