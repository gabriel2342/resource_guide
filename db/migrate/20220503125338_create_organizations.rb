class CreateOrganizations < ActiveRecord::Migration[7.0]
  def change
    create_table :organizations do |t|
      t.references :team, null: false, foreign_key: true
      t.string :name, null: false

      t.timestamps
    end
  end
end
