require 'rails_helper'

RSpec.describe "SCI Facile", type: :system do
  scenario "Guide touristique" do
    visit "/"
    expect(page).to have_content("Gérez votre SCI en toute simplicité")

    # visit new_company_path
    # fill_in "Nom de la SCI", with: "Eloidine"
    # click_button "Créer ce/cette SCI"
    # sleep 10 # Wait for the company to be created

    click_link "Connexion"
    click_link "S'inscrire"

    expect(page).to have_current_path(new_associate_registration_path)
    expect(page).to have_content("S'inscrire")
    fill_in "Nom de votre SCI", with: "Eloidine"
    fill_in "Prénom", with: "David"
    fill_in "Nom", with: "Herelle"
    fill_in "Email", with: "david.herelleh@eloidine.com"
    # fill_in "Nombre de parts", with: "10"
    # fill_in "Apport initial", with: "1000"
    # fill_in "Solde du compte courant", with: "500"
    fill_in "Mot de passe", with: "password"
    fill_in "Confirmation du Mot de passe", with: "password"
    click_button "Créer ce/cette Associé(e)" # "S'inscrire"
    puts page.body if page.has_content?("error")
    expect(page).to have_current_path(company_associates_path(Company.last))
    expect(page).to have_content("David")

    # # Add an associate
    # click_link "Ajouter un associé"
    # fill_in "Prénom", with: "John"
    # fill_in "Nom", with: "Doe"
    # fill_in "Email", with: "john.doe@example.com"
    # fill_in "Nombre de parts", with: "10"
    # fill_in "Apport initial", with: "1000"
    # fill_in "Solde du compte courant", with: "500"
    # click_button "Créer Associé"

    # # Add a property
    # click_link "Ajouter un bien"
    # fill_in "Nom du bien", with: "Maison de vacances"
    # fill_in "Adresse", with: "123 Rue de la Paix, Paris"
    # fill_in "Valeur du bien", with: "250000"
    # click_button "Créer Bien"
  end
end
