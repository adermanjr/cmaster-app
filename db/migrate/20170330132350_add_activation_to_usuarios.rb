class AddActivationToUsuarios < ActiveRecord::Migration[5.0]
  def change
    add_column :usuarios, :activation_digest, :string
    add_column :usuarios, :activated, :boolean, default: false
    add_column :usuarios, :activated_at, :datetime
  end
end
