FactoryBot.define do
  factory :company do
    name { "SCI #{Faker::Company.name}" }

    trait :with_associates do
      after(:create) do |company|
        create_list(:associate, 2, company: company)
      end
    end

    trait :with_properties do
      after(:create) do |company|
        create_list(:property, 1, company: company)
      end
    end

    trait :complete do
      after(:create) do |company|
        create_list(:associate, 3, company: company)
        create_list(:property, 2, company: company)
      end
    end
  end
end
