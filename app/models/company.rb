class Company < ApplicationRecord
  has_many :associates, dependent: :destroy
  has_many :properties, dependent: :destroy
end
