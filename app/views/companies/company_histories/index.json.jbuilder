json.array!(@company_histories) do |company_history|
  json.extract! company_history, :id, :company_id, :short, :name, :address_city, :address_street, :address_house, :address_number, :address_postal_code, :phone, :email, :nip, :regon, :pesel, :informal_group, :note, :user_id, :created_at, :updated_at
  json.url company_company_history_url(company_history.company_id, company_history, format: :json)
end
