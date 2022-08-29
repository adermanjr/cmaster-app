class AddPassoCriacaoToUsuarios < ActiveRecord::Migration[5.2]
  def change
    add_column :usuarios, :passo_criacao, :integer
  end
end
