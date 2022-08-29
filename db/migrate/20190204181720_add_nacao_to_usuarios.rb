class AddNacaoToUsuarios < ActiveRecord::Migration[5.2]
  def change
    add_reference :usuarios, :nacao, foreign_key: true
    add_reference :clubes, :nacao, foreign_key: true
  end
end
