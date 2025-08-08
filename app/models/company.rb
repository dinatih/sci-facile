class Company < ApplicationRecord
  has_many :associates, dependent: :destroy
  has_many :properties, dependent: :destroy
  has_many :general_meetings, dependent: :destroy
  has_many :financial_operations, dependent: :destroy
  has_many :tenants, through: :properties

  validates :name, presence: true, uniqueness: true
end
