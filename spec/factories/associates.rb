# == Schema Information
#
# Table name: associates
#
#  id                      :integer          not null, primary key
#  current_account_balance :decimal(10, 2)   default(0.0), not null
#  current_sign_in_at      :datetime
#  current_sign_in_ip      :string
#  email                   :string           default(""), not null
#  encrypted_password      :string           default(""), not null
#  first_name              :string
#  initial_contribution    :decimal(10, 2)   default(0.0)
#  last_name               :string
#  last_sign_in_at         :datetime
#  last_sign_in_ip         :string
#  remember_created_at     :datetime
#  reset_password_sent_at  :datetime
#  reset_password_token    :string
#  shares_count            :integer          default(0), not null
#  sign_in_count           :integer          default(0), not null
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  company_id              :integer          not null
#
# Indexes
#
#  index_associates_on_company_id            (company_id)
#  index_associates_on_email                 (email) UNIQUE
#  index_associates_on_reset_password_token  (reset_password_token) UNIQUE
#
# Foreign Keys
#
#  company_id  (company_id => companies.id)
#
FactoryBot.define do
  factory :associate do
    company
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    email { Faker::Internet.email(name: "#{I18n.transliterate(first_name)} #{I18n.transliterate(last_name)}") }
    shares_count { rand(1..1000) }
    initial_contribution { rand(1000..50000) }
    current_account_balance { rand(-5000..10000) }
    password { 'password' }
    password_confirmation { 'password' }

    trait :major_associate do
      shares_count { rand(500..1000) }
      initial_contribution { rand(25000..100000) }
      current_account_balance { rand(0..25000) }
    end

    trait :minor_associate do
      shares_count { rand(1..100) }
      initial_contribution { rand(1000..10000) }
      current_account_balance { rand(-1000..5000) }
    end

    trait :with_negative_balance do
      current_account_balance { rand(-10000..-1000) }
    end
  end
end
