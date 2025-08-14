require 'rails_helper'

RSpec.describe "SCI Facile", type: :system do
  def register_associate(company_name:, first_name:, last_name:, email:, password:)
    click_link "Connexion"
    click_link "S'inscrire"

    fill_in "Nom de votre SCI", with: company_name
    fill_in "Prénom", with: first_name
    fill_in "Nom", with: last_name
    fill_in "Email", with: email
    fill_in "Mot de passe", with: password
    fill_in "Confirmation du Mot de passe", with: password
    click_button "Enregistrer cet Associé(e)"
  end

  scenario "Guide touristique" do
    Rails.application.load_seed
    # Seed completed: 1 admin users,5 companies, 15 associates, 20 properties, 10 tenants,
    #                 60 financial operations, 10 general meetings created.
    visit "/"
    current_company = Company.last
    visit company_path(current_company)
    visit company_associates_path(current_company)
    visit company_properties_path(current_company)
    visit company_financial_operations_path(current_company)
    visit company_tenants_path(current_company)
    visit company_general_meetings_path(current_company)

    visit "/"
    register_associate(
      company_name: "Eloidine",
      first_name: "David",
      last_name: "Herelle",
      email: "david.herelleh@eloidine.com",
      password: "password"
    )
  end
end
