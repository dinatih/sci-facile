# == Schema Information
#
# Table name: companies
#
#  id         :integer          not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
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

    trait :realistic do
      name { "SCI Eloidine" }

      after(:create) do |company|
        create(:associate, first_name: "Nicaise 👑", last_name: "Eloidin", initial_contribution: 500000, company: company)
        create(:associate, first_name: "David 👨🏾‍💻", last_name: "Herelle", initial_contribution: 200, company: company)
        create(:associate, first_name: "Virginie 👩🏾‍🔬", last_name: "Herelle", initial_contribution: 200, company: company)
        create(:associate, first_name: "Djanis 💃🏾", last_name: "Fils-Aimé", initial_contribution: 200, company: company)

        props = [
          { description: "Maison Sable d'Olonnes", address: "25 Rue Mathieu Saint-Jouan, 85100 Les Sables-d'Olonne", acquisition_date: "2000-01-01", acquisition_price: 150000 },
          { description: "Appartement Parisien 18eme", address: "86 Rue de la Chapelle, 75018 Paris", acquisition_date: "2005-01-01", acquisition_price: 175000 },
          { description: "Chambre de bonne Parisien 6eme", address: "127 Rue Notre Dame des Champs, 75006 Paris", acquisition_date: "2022-01-01", acquisition_price: 110000 },
          { description: "Appartement Parisien 13eme", address: "65 Rue du Chevaleret, 75013 Paris", acquisition_date: "2024-05-01", acquisition_price: 200000 },
          { description: "Appartement Fort de France", address: "à définir, 97200 Fort de France", acquisition_date: "2024-01-01", acquisition_price: 150000 }
        ]

        props.map.with_index do |attrs, idx|
          create(:property, attrs.merge(company: company)).tap do |property|
            tenant = create(:tenant, property: property, charges_amount: rand(50..150), rent_amount: rand(800..1500))
            12.times do |i|
              create(:financial_operation,
                category: "income",
                operation_type: "rent",
                label: "Loyer + Charges",
                amount: tenant.rent_amount + tenant.charges_amount,
                company: company,
                property: property,
                tenant: tenant,
                operation_date: (Date.current - 11.months + i.months).beginning_of_month
              )
            end
          end
        end
        # Ajoute 100 opérations financières randomisées
        create_list(:financial_operation, 100, :random_invoice, company: company)
      end
    end
  end
end
