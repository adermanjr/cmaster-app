class AddNomeTimeToUsuarios < ActiveRecord::Migration[5.2]
  def change
    add_column :usuarios, :nome_time, :string
  end
end
