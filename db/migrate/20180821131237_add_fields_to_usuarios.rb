class AddFieldsToUsuarios < ActiveRecord::Migration[5.0]
  def change
    add_column :usuarios, :tipo_usuario, :integer
    add_column :usuarios, :logradouro, :string
    add_column :usuarios, :numero_logr, :string
    add_column :usuarios, :complemento, :string
    add_column :usuarios, :bairro, :string
    add_column :usuarios, :cidade, :string
    add_column :usuarios, :est_id, :integer
    add_column :usuarios, :cep, :string
    add_column :usuarios, :tel1, :string
    add_column :usuarios, :tel2, :string
    add_column :usuarios, :lat, :string
    add_column :usuarios, :lng, :string
    add_column :usuarios, :lingua, :string
    add_column :usuarios, :fuso, :string
    add_column :usuarios, :estado_id, :integer
    add_column :usuarios, :numero_cartao, :string
    add_column :usuarios, :nome_cartao, :string
    add_column :usuarios, :dtexpirado, :string
    add_column :usuarios, :bandeira_cartao, :string
  end
end
