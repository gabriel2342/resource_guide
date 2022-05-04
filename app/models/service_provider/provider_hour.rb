class ServiceProvider::ProviderHour < ApplicationRecord
  # 🚅 add concerns above.

  belongs_to :service_provider
  belongs_to :hour
  # 🚅 add belongs_to associations above.

  # 🚅 add has_many associations above.

  # 🚅 add has_one associations above.

  # 🚅 add scopes above.

  validates :service_provider, scope: true
  # 🚅 add validations above.

  # 🚅 add callbacks above.

  # 🚅 add delegations above.

  def valid_service_providers
    municipality.valid_service_providers
  end

  def valid_service_providers
    municipality.valid_service_providers
  end

  # 🚅 add methods above.
end
