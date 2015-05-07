json.array!(@insurances) do |insurance|
  json.extract! insurance, :id, :number, :concluded, :valid_from, :applies_to, :pay, :discounts_lock, :note, :company_id
  json.url insurance_url(insurance, format: :json)
end
