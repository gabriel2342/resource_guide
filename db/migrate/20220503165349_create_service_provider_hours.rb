class CreateServiceProviderHours < ActiveRecord::Migration[7.0]
  def change
    create_table :service_provider_hours do |t|
      t.references :hour, null: false, foreign_key: true
      t.references :service_provider, null: false, foreign_key: true

      t.timestamps
    end
  end
end
