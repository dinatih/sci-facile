class Company < ApplicationRecord
  has_many :associates, dependent: :destroy
end
