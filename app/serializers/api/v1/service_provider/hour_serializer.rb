class Api::V1::ServiceProvider::HourSerializer < Api::V1::ApplicationSerializer
  set_type "service_provider/hour"

  attributes :id,
    :municipality_id,
    :name,
    # 🚅 super scaffolding will insert new fields above this line.
    :created_at,
    :updated_at

  belongs_to :municipality, serializer: Api::V1::MunicipalitySerializer
end
