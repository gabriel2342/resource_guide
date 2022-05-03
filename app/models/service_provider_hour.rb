class ServiceProviderHour < ApplicationRecord
  belongs_to :hour
  belongs_to :service_provider
end
