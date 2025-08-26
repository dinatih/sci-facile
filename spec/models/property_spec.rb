# == Schema Information
#
# Table name: properties
#
#  id                :integer          not null, primary key
#  acquisition_date  :date
#  acquisition_price :decimal(, )
#  address           :string
#  description       :text
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  company_id        :integer          not null
#
# Indexes
#
#  index_properties_on_company_id  (company_id)
#
# Foreign Keys
#
#  company_id  (company_id => companies.id)
#
require 'rails_helper'

RSpec.describe Property, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
