class Api::V1::ServiceProviderSerializer < Api::V1::ApplicationSerializer
  set_type "service_provider"

  attributes :id,
    :municipality_id,
    :name,
    :about,
    :street,
    :city,
    :state,
    :zip,
    :contact_person,
    :phone,
    :email,
    :logo,
    :url,
    # 🚅 super scaffolding will insert new fields above this line.
    :created_at,
    :updated_at

  belongs_to :municipality, serializer: Api::V1::MunicipalitySerializer
end
