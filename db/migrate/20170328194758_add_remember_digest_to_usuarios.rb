class AddRememberDigestToUsuarios < ActiveRecord::Migration[5.0]
  def change
    add_column :usuarios, :remember_digest, :string
  end
end
