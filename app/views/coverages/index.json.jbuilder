json.array!(@coverages) do |coverage|
  json.extract! coverage, :id, :rotation_id, :group_id, :insured_id, :payer_id, :note
  json.url coverage_url(coverage, format: :json)
end
