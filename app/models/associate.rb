class Associate < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :trackable,
         :recoverable, :rememberable, :validatable

  belongs_to :company
  has_many :financial_operations, dependent: :destroy

  accepts_nested_attributes_for :company, allow_destroy: true

  # Returns the percentage of shares held by this associate in the company
  def shares_percentage
    total = company.associates.sum(:shares_count)
    return 0 if total.zero?
    (shares_count.to_f / total * 100).round(2)
  end

  # Returns the full name of the associate
  def full_name
    [ first_name, last_name ].compact.join(" ")
  end
end
