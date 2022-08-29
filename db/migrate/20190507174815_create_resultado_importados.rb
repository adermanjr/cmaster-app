class CreateResultadoImportados < ActiveRecord::Migration[5.2]
  def change
    create_table :resultado_importados do |t|
      t.integer :classif
      t.string :ring
      t.integer :year 
      t.string :p_sn
      t.string :d_sn
      t.string :e_sn
      t.integer :idcriador
      t.string :nomecriador
      t.string :date
      t.string :time
      t.float :distance
      t.float :veloc
      t.integer :points

      t.timestamps
    end
  end
end
