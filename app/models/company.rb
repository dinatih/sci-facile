# == Schema Information
#
# Table name: companies
#
#  id         :integer          not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Company < ApplicationRecord
  has_many :associates, dependent: :destroy
  has_many :properties, dependent: :destroy
  has_many :general_meetings, dependent: :destroy
  has_many :financial_operations, dependent: :destroy
  has_many :tenants, through: :properties

  validates :name, presence: true, uniqueness: true
end
