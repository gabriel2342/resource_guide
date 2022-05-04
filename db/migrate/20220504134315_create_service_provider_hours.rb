class CreateServiceProviderHours < ActiveRecord::Migration[7.0]
  def change
    create_table :service_provider_hours do |t|
      t.references :municipality, null: false, foreign_key: true
      t.string :name

      t.timestamps
    end
  end
end
