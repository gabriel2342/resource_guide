class CreateMunicipalities < ActiveRecord::Migration[7.0]
  def change
    create_table :municipalities do |t|
      t.references :organization, null: false, foreign_key: true
      t.string :name, null: false
      t.string :url

      t.timestamps
    end
  end
end
