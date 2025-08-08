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
