FactoryBot.define do
  factory :tenant do
    property
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    email { Faker::Internet.email(name: "#{I18n.transliterate(first_name)} #{I18n.transliterate(last_name)}") }
    rent_amount { rand(400..1500) }
    charges_amount { rand(50..200) }
    lease_start_date { rand(2.years.ago..6.months.ago).to_date }
    lease_end_date { lease_start_date + rand(1..3).years }

    trait :high_rent do
      rent_amount { rand(1200..2500) }
      charges_amount { rand(150..300) }
    end

    trait :low_rent do
      rent_amount { rand(300..700) }
      charges_amount { rand(30..100) }
    end

    trait :current_lease do
      lease_start_date { rand(1.year.ago..Date.current) }
      lease_end_date { rand(Date.current..2.years.from_now) }
    end

    trait :expired_lease do
      lease_start_date { rand(3.years.ago..1.year.ago) }
      lease_end_date { rand(6.months.ago..Date.current) }
    end

    trait :future_lease do
      lease_start_date { rand(Date.current..3.months.from_now) }
      lease_end_date { lease_start_date + rand(1..3).years }
    end
  end
end
