json.extract! financial_operation, :id, :company_id, :property_id, :tenant_id, :associate_id, :category, :label, :amount, :date, :created_at, :updated_at
json.url financial_operation_url(financial_operation, format: :json)
