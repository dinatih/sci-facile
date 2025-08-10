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

    trait :with_property_from_company do
      after(:build) do |financial_operation|
        # Si la company existe et a déjà des propriétés, on en prend une au hasard
        if financial_operation.company&.properties&.any?
          financial_operation.property = financial_operation.company.properties.sample
        else
          # Sinon, on crée une nouvelle propriété liée à la même company
          financial_operation.property = FactoryBot.build(:property, :with_tenant, company: financial_operation.company)
        end
      end
    end

    trait :with_property_with_tenant_from_company do
      after(:build) do |financial_operation|
        # Si la company existe et a déjà des propriétés, on en prend une au hasard
        if financial_operation.company&.properties&.any?
          financial_operation.property = financial_operation.company.properties.sample
          financial_operation.tenant = financial_operation.property.tenants.sample # if financial_operation.property.tenants.any?
        else
          # Sinon, on crée une nouvelle propriété liée à la même company
          financial_operation.property = FactoryBot.build(:property, :with_tenant, company: financial_operation.company)
        end
      end
    end

    trait :rental_income do
      category { "recette" }
      label { "Loyer" }
      amount { rand(400..1500) }
      with_property_with_tenant_from_company
    end

    trait :expense do
      category { "dépense" }
      label { %w[Travaux Charges Assurance Taxe].sample }
      amount { rand(50..2000) }
      with_property_from_company
    end

    trait :contribution do
      category { "apport" }
      label { "Apport en compte courant" }
      amount { rand(1000..10000) }
      associate { association :associate, company: company }
    end

    trait :reimbursement do
      category { "remboursement" }
      label { "Remboursement compte courant" }
      amount { rand(500..5000) }
      associate { association :associate, company: company }
    end

    trait :maintenance do
      category { "dépense" }
      label { "Travaux de maintenance" }
      amount { rand(200..3000) }
      property { association :property, company: company }
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
