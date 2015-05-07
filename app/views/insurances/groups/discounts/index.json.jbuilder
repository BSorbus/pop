json.array!(@discounts) do |discount|
  json.extract! discount, :id, :category, :description, :discount_increase, :group_id
  json.url discount_url(discount, format: :json)
end
