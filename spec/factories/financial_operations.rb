FactoryBot.define do
  factory :financial_operation do
    company
    property { nil }
    tenant { nil }
    associate { nil }
    category { %w[recette dépense apport remboursement].sample }
    label { "Opération #{category}" }
    amount { rand(100..5000) }
    date { Faker::Date.between(from: 1.year.ago, to: Date.current) }

    trait :rental_income do
      category { "recette" }
      label { "Loyer" }
      amount { rand(400..1500) }
      property
      tenant
    end

    trait :expense do
      category { "dépense" }
      label { %w[Travaux Charges Assurance Taxe].sample }
      amount { rand(50..2000) }
      property
    end

    trait :contribution do
      category { "apport" }
      label { "Apport en compte courant" }
      amount { rand(1000..10000) }
      associate
    end

    trait :reimbursement do
      category { "remboursement" }
      label { "Remboursement compte courant" }
      amount { rand(500..5000) }
      associate
    end

    trait :maintenance do
      category { "dépense" }
      label { "Travaux de maintenance" }
      amount { rand(200..3000) }
      property
    end

    trait :large_amount do
      amount { rand(5000..50000) }
    end

    trait :recent do
      date { rand(1.month.ago..Date.current) }
    end

    trait :last_year do
      date { rand(1.year.ago..1.month.ago) }
    end
  end
end
