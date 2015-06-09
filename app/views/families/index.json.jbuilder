json.array!(@families) do |family|
  json.extract! family, :id, :number, :proposal_number, :concluded, :valid_from, :applies_to, :pay, :protection_variant, :assurance, :assurance_component, :family_lock, :note, :company_id, :user_id
  json.url family_url(family, format: :json)
end
