# == Schema Information
#
# Table name: financial_operations
#
#  id               :integer          not null, primary key
#  amount           :decimal(10, 2)
#  category         :string
#  description      :text
#  label            :string
#  metadata         :json
#  operation_date   :date             not null
#  operation_type   :string
#  reference_number :string
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  associate_id     :integer
#  company_id       :integer          not null
#  property_id      :integer
#  tenant_id        :integer
#
# Indexes
#
#  idx_on_company_id_category_operation_date_9cfb5aa3fa          (company_id,category,operation_date)
#  index_financial_operations_on_associate_id                    (associate_id)
#  index_financial_operations_on_associate_id_and_category       (associate_id,category)
#  index_financial_operations_on_category                        (category)
#  index_financial_operations_on_company_id                      (company_id)
#  index_financial_operations_on_company_id_and_category         (company_id,category)
#  index_financial_operations_on_company_id_and_operation_date   (company_id,operation_date)
#  index_financial_operations_on_operation_date                  (operation_date)
#  index_financial_operations_on_operation_type                  (operation_type)
#  index_financial_operations_on_property_id                     (property_id)
#  index_financial_operations_on_property_id_and_operation_date  (property_id,operation_date)
#  index_financial_operations_on_tenant_id                       (tenant_id)
#
# Foreign Keys
#
#  associate_id  (associate_id => associates.id)
#  company_id    (company_id => companies.id)
#  property_id   (property_id => properties.id)
#  tenant_id     (tenant_id => tenants.id)
#
require 'rails_helper'

RSpec.describe FinancialOperation, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
