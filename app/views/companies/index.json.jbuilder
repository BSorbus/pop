json.array!(@companies) do |company|
  json.extract! company, :id, :short, :name, :address_city, :address_street, :address_house, :address_number, :address_postal_code, :phone, :email, :nip, :regon, :pesel, :informal_group, :note, :user_id
  json.url company_url(company, format: :json)
end
