json.extract! hour,
  :id,
  :municipality_id,
  :name,
  # 🚅 super scaffolding will insert new fields above this line.
  :created_at,
  :updated_at
json.url account_service_provider_hour_url(hour, format: :json)
