class Api::V1::OrganizationSerializer < Api::V1::ApplicationSerializer
  set_type "organization"

  attributes :id,
    :team_id,
    :name,
    # 🚅 super scaffolding will insert new fields above this line.
    :created_at,
    :updated_at

  belongs_to :team, serializer: Api::V1::TeamSerializer
end
