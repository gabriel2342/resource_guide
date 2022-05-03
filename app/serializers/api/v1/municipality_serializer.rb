class Api::V1::MunicipalitySerializer < Api::V1::ApplicationSerializer
  set_type "municipality"

  attributes :id,
    :organization_id,
    :name,
    :url,
    # 🚅 super scaffolding will insert new fields above this line.
    :created_at,
    :updated_at

  belongs_to :organization, serializer: Api::V1::OrganizationSerializer
end
