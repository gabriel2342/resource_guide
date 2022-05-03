class CreateServiceProviders < ActiveRecord::Migration[7.0]
  def change
    create_table :service_providers do |t|
      t.string :name, null: false
      t.text :about
      t.string :street
      t.string :city
      t.string :state
      t.string :zip
      t.string :contact_person
      t.string :phone, null: false
      t.string :email
      t.string :url
      t.references :municipality, null: false, foreign_key: true

      t.timestamps
    end
  end
end
