json.extract! municipality,
  :id,
  :organization_id,
  :name,
  :url,
  # 🚅 super scaffolding will insert new fields above this line.
  :created_at,
  :updated_at
json.url account_municipality_url(municipality, format: :json)
