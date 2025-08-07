json.extract! tenant, :id, :property_id, :first_name, :last_name, :email, :rent_amount, :charges_amount, :lease_start_date, :lease_end_date, :created_at, :updated_at
json.url tenant_url(tenant, format: :json)
