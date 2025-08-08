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

    trait :sci_eloidine do
      name { "SCI Eloidine" }

      associate { { first_name: "Nicaise 👩‍👧‍👦", last_name: "Eloidin" } }
      associate { { first_name: "David 👨🏾‍💻", last_name: "Herelle" } }
      associate { { first_name: "Virginie 👩🏾‍🔬", last_name: "Herelle" } }
      associate { { first_name: "Djanis 💃🏾", last_name: "Fils-Aimé" } }

      property { { name: "Maison Sable d'Olonnes", address: "25 Rue Mathieu Saint-Jouan, 85100 Les Sables-d'Olonne", acquisition_date: "2000", acquisition_price: 150000 } }
      property { { name: "Appartement Parisien 18eme", address: "86 Rue de la Chapelle, 75018 Paris", acquisition_date: "2005", acquisition_price: 175000 } }
      property { { name: "Chambre de bonne Parisien 6eme", address: "127 Rue Notre Dame des Champs, 75006 Paris", acquisition_date: "2022", acquisition_price: 110000 } }
      property { { name: "Appartement Parisien 13eme", address: "65 Rue du Chevaleret, 75013 Paris", acquisition_date: "2024-05-01", acquisition_price: 200000 } }
      property { { name: "Appartement Fort de France", address: "à définir, 97200 Fort de France", acquisition_date: "2024", acquisition_price: 150000 } }
    end
  end
end
