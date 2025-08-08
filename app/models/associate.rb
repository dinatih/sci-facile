class Associate < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :trackable,
         :recoverable, :rememberable, :validatable

  belongs_to :company
  has_many :financial_operations, dependent: :destroy

  accepts_nested_attributes_for :company, allow_destroy: true
end
