FactoryBot.define do
  factory :financial_operation do
    company
    property { nil }
    tenant { nil }
    associate { nil }
    # Use enum KEYS (see FinancialOperation enum :category)
    category { %w[income expense contribution refund].sample }
    # operation_type will be aligned with category in after(:build)
    operation_type { nil }
    label { "Opération #{category}" }
    amount { rand(100..5000) }
    operation_date { Faker::Date.between(from: 1.year.ago, to: Date.current) }

    trait :with_associate_from_company do
      after(:build) do |financial_operation|
        # Si la company existe et a déjà des associés, on en prend un au hasard
        if financial_operation.company&.associates&.any?
          financial_operation.associate = financial_operation.company.associates.sample
        else
          # Sinon, on crée une nouvelle propriété liée à la même company
          financial_operation.associate = FactoryBot.create(:associate, company: financial_operation.company)
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
          financial_operation.property = FactoryBot.create(:property, :with_tenant, company: financial_operation.company)
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
            financial_operation.property = FactoryBot.create(:property, :with_tenant, company: financial_operation.company)
            financial_operation.tenant = financial_operation.property.tenants.sample
          end
        else
          financial_operation.property = FactoryBot.create(:property, :with_tenant, company: financial_operation.company)
          financial_operation.tenant = financial_operation.property.tenants.sample
        end
      end
    end

    trait :rental_income do
      category { "income" }
      operation_type { "rent" }
      label { "Loyer" }
      amount { rand(400..1500) }
      with_property_with_tenant_from_company
    end

    trait :expense do
      category { "expense" }
      operation_type { "charges" }
      label { %w[Travaux Charges Assurance Taxe].sample }
      amount { rand(50..2000) }
      with_property_from_company
    end

    trait :contribution do
      category { "contribution" }
      label { "Apport en compte courant" }
      amount { rand(1000..10000) }
      with_associate_from_company
    end

    trait :reimbursement do
      category { "refund" }
      label { "Remboursement compte courant" }
      amount { rand(500..5000) }
      with_associate_from_company
    end

    trait :maintenance do
      category { "expense" }
      operation_type { "maintenance" }
      label { "Travaux de maintenance" }
      amount { rand(200..3000) }
      with_property_from_company
    end

    trait :large_amount do
      category { "expense" }
      operation_type { "maintenance" }
      with_property_with_tenant_from_company
      label { "Frais importants" }
      amount { rand(5000..50000) }
    end

    trait :recent do
      category { "income" }
      operation_type { "rent" }
      with_property_with_tenant_from_company
      label { "Loyer" }
      amount { rand(400..1500) }
      operation_date { Faker::Date.between(from: 1.month.ago, to: Date.current) }
    end

    trait :last_year do
      category { "income" }
      operation_type { "rent" }
      label { "Loyer" }
      amount { rand(400..1500) }
      with_property_with_tenant_from_company
      operation_date { Faker::Date.between(from: 1.year.ago, to: 1.month.ago) }
    end

    trait :monthly_rent do
      category { "income" }
      operation_type { "rent" }
      label { "Loyer mensuel" }
      amount { rand(400..1500) }
      with_property_with_tenant_from_company
    end

    trait :condo_charges do
      category { "expense" }
      operation_type { "charges" }
      label { "Charges de copropriété" }
      amount { rand(50..500) }
      with_property_from_company
    end

    trait :insurance do
      category { "expense" }
      operation_type { "insurance" }
      label { "Assurance habitation" }
      amount { rand(100..400) }
      with_property_from_company
    end

    trait :property_tax do
      category { "expense" }
      operation_type { "tax" }
      label { "Taxe foncière" }
      amount { rand(200..1200) }
      with_property_from_company
    end

    trait :garbage_tax do
      category { "expense" }
      operation_type { "tax" }
      label { "Taxe d’enlèvement des ordures ménagères" }
      amount { rand(50..300) }
      with_property_from_company
    end

    trait :renovation do
      category { "expense" }
      operation_type { "maintenance" }
      label { "Travaux de rénovation" }
      amount { rand(500..5000) }
      with_property_from_company
    end

    trait :management_fees do
      category { "expense" }
      operation_type { "charges" }
      label { "Frais de gestion locative" }
      amount { rand(100..500) }
      with_property_from_company
    end

    trait :agency_fees do
      category { "expense" }
      operation_type { "charges" }
      label { "Frais d’agence immobilière" }
      amount { rand(200..1000) }
      with_property_from_company
    end

    trait :water_bill do
      category { "expense" }
      operation_type { "charges" }
      label { "Facture d’eau" }
      amount { rand(30..150) }
      with_property_from_company
    end

    trait :electricity_bill do
      category { "expense" }
      operation_type { "charges" }
      label { "Facture d’électricité" }
      amount { rand(40..200) }
      with_property_from_company
    end

    trait :gas_bill do
      category { "expense" }
      operation_type { "charges" }
      label { "Facture de gaz" }
      amount { rand(30..180) }
      with_property_from_company
    end

    trait :internet_bill do
      category { "expense" }
      operation_type { "charges" }
      label { "Facture internet" }
      amount { rand(20..80) }
      with_property_from_company
    end

    trait :equipment_replacement do
      category { "expense" }
      operation_type { "maintenance" }
      label { "Remplacement d’équipement" }
      amount { rand(200..2000) }
      with_property_from_company
    end

    trait :initial_contribution do
      category { "contribution" }
      operation_type { "initial_contribution" }
      label { "Apport initial" }
      amount { rand(1000..10000) }
      with_associate_from_company
    end

    trait :current_account_contribution do
      category { "contribution" }
      operation_type { "current_account_contribution" }
      label { "Apport en compte courant d’associé" }
      amount { rand(1000..10000) }
      with_associate_from_company
    end

    trait :current_account_refund do
      category { "refund" }
      operation_type { "current_account_refund" }
      label { "Remboursement compte courant d’associé" }
      amount { rand(500..5000) }
      with_associate_from_company
    end

    trait :notary_fees do
      category { "expense" }
      operation_type { "charges" }
      label { "Frais de notaire" }
      amount { rand(500..3000) }
      with_property_from_company
    end

    trait :syndic_fees do
      category { "expense" }
      operation_type { "charges" }
      label { "Frais de syndic" }
      amount { rand(100..800) }
      with_property_from_company
    end

    trait :urgent_repair do
      category { "expense" }
      operation_type { "maintenance" }
      label { "Frais de réparation urgente" }
      amount { rand(200..2000) }
      with_property_from_company
    end

    trait :exceptional_expense do
      category { "expense" }
      operation_type { "other" }
      label { "Dépense exceptionnelle" }
      amount { rand(500..5000) }
      with_property_from_company
    end

    trait :random_facture do
      transient do
        available_traits { [
          :monthly_rent, :condo_charges, :insurance, :property_tax, :garbage_tax,
          :renovation, :management_fees, :agency_fees, :water_bill, :electricity_bill,
          :gas_bill, :internet_bill, :equipment_replacement, :initial_contribution,
          :current_account_contribution, :current_account_refund, :notary_fees,
          :syndic_fees, :urgent_repair, :exceptional_expense
        ] }
      end

      after(:build) do |fo, evaluator|
        trait_to_apply = evaluator.available_traits.sample
        FactoryBot.build(:financial_operation, trait_to_apply, company: fo.company)
          .attributes.each { |attr, value| fo.send("#{attr}=", value) unless attr == "id" }
      end
    end
  end
end
