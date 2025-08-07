# spec/factories/properties.rb
FactoryBot.define do
  factory :property do
    company
    address { Faker::Address.full_address }
    description { "Appartement de #{rand(2..5)} pièces, #{rand(40..120)}m²" }
    acquisition_date { rand(10.years.ago..1.year.ago).to_date }
    acquisition_price { rand(100000..500000) }

    trait :apartment do
      description { "Appartement T#{rand(2..4)} de #{rand(45..85)}m²" }
      acquisition_price { rand(150000..350000) }
    end

    trait :house do
      description { "Maison individuelle de #{rand(80..150)}m² avec jardin" }
      acquisition_price { rand(200000..600000) }
    end

    trait :commercial do
      description { "Local commercial de #{rand(30..100)}m²" }
      acquisition_price { rand(80000..300000) }
    end

    trait :recent_acquisition do
      acquisition_date { rand(1.year.ago..Date.current) }
    end

    trait :old_acquisition do
      acquisition_date { rand(20.years.ago..5.years.ago) }
    end

    trait :with_tenant do
      after(:create) do |property|
        create(:tenant, property: property)
      end
    end
  end
end
