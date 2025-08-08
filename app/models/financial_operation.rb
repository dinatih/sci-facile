class FinancialOperation < ApplicationRecord
  belongs_to :company
  belongs_to :property, optional: true
  belongs_to :tenant, optional: true
  belongs_to :associate, optional: true
end
