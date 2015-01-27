json.array!(@currencies) do |currency|
  json.extract! currency, :id, :value, :user_id
  json.url currency_url(currency, format: :json)
end
