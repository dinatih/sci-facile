# == Schema Information
#
# Table name: tenants
#
#  id               :integer          not null, primary key
#  charges_amount   :decimal(, )
#  email            :string
#  first_name       :string
#  last_name        :string
#  lease_end_date   :date
#  lease_start_date :date
#  rent_amount      :decimal(, )
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  property_id      :integer          not null
#
# Indexes
#
#  index_tenants_on_property_id  (property_id)
#
# Foreign Keys
#
#  property_id  (property_id => properties.id)
#
require 'rails_helper'

RSpec.describe Tenant, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
