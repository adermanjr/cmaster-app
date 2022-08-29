class AddLocaleToNacaos < ActiveRecord::Migration[5.2]
  def change
    add_column :nacaos, :locale, :string
  end
end
