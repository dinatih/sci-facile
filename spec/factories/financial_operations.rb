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

    trait :with_associate_from_company do
      after(:build) do |financial_operation|
        # Si la company existe et a déjà des associés, on en prend un au hasard
        if financial_operation.company&.associates&.any?
          financial_operation.associate = financial_operation.company.associates.sample
        else
          # Sinon, on crée une nouvelle propriété liée à la même company
          financial_operation.associate = FactoryBot.build(:associate, company: financial_operation.company)
        end
      end
    end

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
        if financial_operation.company&.properties&.any?
          # On filtre les propriétés ayant au moins un tenant
          properties_with_tenant = financial_operation.company.properties.select { |p| p.tenants.any? }
          if properties_with_tenant.any?
            financial_operation.property = properties_with_tenant.sample
            financial_operation.tenant = financial_operation.property.tenants.sample
          else
            # Si aucune propriété n'a de tenant, on en crée une nouvelle avec tenant
            financial_operation.property = FactoryBot.build(:property, :with_tenant, company: financial_operation.company)
            financial_operation.tenant = financial_operation.property.tenants.sample
          end
        else
          financial_operation.property = FactoryBot.build(:property, :with_tenant, company: financial_operation.company)
          financial_operation.tenant = financial_operation.property.tenants.sample
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
      with_associate_from_company
    end

    trait :reimbursement do
      category { "remboursement" }
      label { "Remboursement compte courant" }
      amount { rand(500..5000) }
      with_associate_from_company
    end

    trait :maintenance do
      category { "dépense" }
      label { "Travaux de maintenance" }
      amount { rand(200..3000) }
      with_property_from_company
    end

    trait :large_amount do
      amount { rand(5000..50000) }
    end

    trait :recent do
      date { Faker::Date.between(from: 1.month.ago, to: Date.current) }
    end

    trait :last_year do
      date { Faker::Date.between(from: 1.year.ago, to: 1.month.ago) }
    end
  end
end
