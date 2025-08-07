# spec/factories/sequences.rb (optionnel - pour des séquences personnalisées)
FactoryBot.define do
  sequence :sci_name do |n|
    "SCI Immobilière #{n.to_s.rjust(3, '0')}"
  end

  sequence :property_address do |n|
    "#{n} rue de la République, #{%w[Paris Lyon Marseille Toulouse].sample}"
  end

  sequence :email do |n|
    "user#{n}@example.com"
  end
end
