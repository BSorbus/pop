json.array!(@groups) do |group|
  json.extract! group, :id, :number, :quotation, :tariff_fixed, :full_range, :risk_group, :assurance, :assurance_component, :treatment, :treatment_component, :ambulatory, :ambulatory_component, :hospital, :hospital_component, :infarct, :infarct_component, :inability, :inability_component, :death_100_percent, :sum_component, :sum_after_discounts, :sum_after_increases, :sum_after_monthly, :insurance_id
  json.url insurance_groups_url(group, format: :json)
end
