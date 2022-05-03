json.extract! organization,
  :id,
  :team_id,
  :name,
  # 🚅 super scaffolding will insert new fields above this line.
  :created_at,
  :updated_at
json.url account_organization_url(organization, format: :json)
