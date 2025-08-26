# == Schema Information
#
# Table name: general_meetings
#
#  id           :integer          not null, primary key
#  date         :date
#  minutes_text :text
#  title        :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  company_id   :integer          not null
#
# Indexes
#
#  index_general_meetings_on_company_id  (company_id)
#
# Foreign Keys
#
#  company_id  (company_id => companies.id)
#
FactoryBot.define do
  factory :general_meeting do
    company
    date { Faker::Date.between(from: 2.years.ago, to: Date.current) }
    title { "Assemblée Générale #{date.year}" }
    minutes_text do
      <<~TEXT
        Assemblée Générale de la SCI #{company.name}

        Date: #{date.strftime('%d/%m/%Y')}
        Présents: #{company.associates.pluck(:first_name, :last_name).map { |fn, ln| "#{fn} #{ln}" }.join(', ')}

        Ordre du jour:
        - Approbation des comptes de l'exercice #{date.year - 1}
        - Affectation du résultat
        - Questions diverses

        Les comptes ont été approuvés à l'unanimité.
        #{Faker::Lorem.paragraph(sentence_count: 3)}
      TEXT
    end

    trait :annual do
      title { "Assemblée Générale Ordinaire #{date.year}" }
      date { Date.new(rand(2.years.ago.year..Date.current.year), [ 3, 4, 5, 6 ].sample, rand(1..28)) }
    end

    trait :extraordinary do
      title { "Assemblée Générale Extraordinaire" }
      minutes_text do
        <<~TEXT
          Assemblée Générale Extraordinaire de la SCI #{company.name}

          Date: #{date.strftime('%d/%m/%Y')}

          Ordre du jour extraordinaire:
          - Modification des statuts
          - Décision d'acquisition d'un nouveau bien

          #{Faker::Lorem.paragraph(sentence_count: 4)}
        TEXT
      end
    end

    trait :recent do
      date { Faker::Date.between(from: 6.months.ago, to: Date.current) }
    end

    trait :old do
      date { Faker::Date.between(from: 5.years.ago, to: 1.year.ago) }
    end
  end
end
