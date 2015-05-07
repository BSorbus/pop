json.array!(@individuals) do |individual|
  json.extract! individual, :id, :first_name, :last_name, :address_city, :address_street, :address_house, :address_number, :address_postal_code, :pesel, :birth_date, :profession, :note, :user_id
  json.url individual_url(individual, format: :json)
end
