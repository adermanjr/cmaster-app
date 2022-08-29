class RemoveCamposFromUsuarios < ActiveRecord::Migration[5.2]
  def change
    remove_column :usuarios, :logradouro, :string
    remove_column :usuarios, :numero_logr, :string
    remove_column :usuarios, :complemento, :string
    remove_column :usuarios, :bairro, :string
    remove_column :usuarios, :cidade, :string
    remove_column :usuarios, :est_id, :integer
    remove_column :usuarios, :cep, :string
  end
end
