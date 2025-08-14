require 'rails_helper'

RSpec.describe "SCI Facile", type: :system do
  def register_associate(company_name:, first_name:, last_name:, email:, password:)
    click_link "Connexion"
    click_link "S'inscrire"

    expect(page).to have_current_path(new_associate_registration_path)
    expect(page).to have_content("S'inscrire")
    fill_in "Nom de votre SCI", with: company_name
    fill_in "Prénom", with: first_name
    fill_in "Nom", with: last_name
    fill_in "Email", with: email
    fill_in "Mot de passe", with: password
    fill_in "Confirmation du Mot de passe", with: password
    click_button "Créer ce/cette Associé(e)"
    puts page.body if page.has_content?("error")
    expect(page).to have_current_path(company_associates_path(Company.last))
    expect(page).to have_content(first_name)
  end

  scenario "Guide touristique" do
    Rails.application.load_seed
    # Seed completed: 1 admin users,5 companies, 15 associates, 20 properties, 10 tenants,
    #                 60 financial operations, 10 general meetings created.

    visit "/"
    expect(page).to have_content("Gérez votre SCI en toute simplicité")

    current_company = Company.last
    visit company_path(current_company)
    visit company_associates_path(current_company)
    visit company_properties_path(current_company)
    visit company_financial_operations_path(current_company)
    visit company_tenants_path(current_company)
    visit company_general_meetings_path(current_company)

    # expect(page).to have_content("Gérez votre SCI en toute simplicité")
    # sleep 5
    # register_associate(
    #   company_name: "Eloidine",
    #   first_name: "David",
    #   last_name: "Herelle",
    #   email: "david.herelleh@eloidine.com",
    #   password: "password"
    # )





    # # Add a property
    # click_link "Ajouter un bien"
    # fill_in "Nom du bien", with: "Maison de vacances"
    # fill_in "Adresse", with: "123 Rue de la Paix, Paris"
    # fill_in "Valeur du bien", with: "250000"
    # click_button "Créer Bien"
  end
end
