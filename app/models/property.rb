class Property < ApplicationRecord
  belongs_to :company
  has_many :financial_operations, dependent: :destroy
  has_many :tenants, dependent: :destroy
end
