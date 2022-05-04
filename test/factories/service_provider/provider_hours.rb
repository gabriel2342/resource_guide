FactoryBot.define do
  factory :service_provider_provider_hour, class: 'ServiceProvider::ProviderHour' do
    service_provider { nil }
    hour { nil }
  end
end
