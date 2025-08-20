require 'rails_helper'

RSpec.describe "SCI Facile", type: :system do
  def register_associate(company_name:, first_name:, last_name:, email:, password:)
    click_link "Connexion"
    click_link "S'inscrire"

    fill_in Company.human_attribute_name(:name), with: company_name
    fill_in Associate.human_attribute_name(:first_name), with: first_name
    fill_in Associate.human_attribute_name(:last_name), with: last_name
    fill_in Associate.human_attribute_name(:email), with: email
    fill_in Associate.human_attribute_name(:password), with: password
    fill_in Associate.human_attribute_name(:password_confirmation), with: password
    click_button "Enregistrer cet Associé(e)"
  end

  def associates_crud(current_company)
    visit company_associates_path(current_company)
    click_link I18n.t("associates.index.new_link")
    fill_in Associate.human_attribute_name(:first_name), with: "Alice"
    fill_in Associate.human_attribute_name(:last_name), with: "Dupont"
    fill_in Associate.human_attribute_name(:email), with: "alice.dupont@example.com"
    fill_in Associate.human_attribute_name(:password), with: "password"
    fill_in Associate.human_attribute_name(:password_confirmation), with: "password"
    click_button I18n.t("helpers.submit.associate.create")

    # Vérifier la redirection vers le show de l'associé
    new_associate = Associate.find_by(email: "alice.dupont@example.com")
    expect(page).to have_current_path(company_associate_path(current_company, new_associate))
    expect(page).to have_content("Alice")
    expect(page).to have_content("Dupont")
    expect(page).to have_content("alice.dupont@example.com")

    # Cliquer sur "Modifier" et éditer une donnée
    click_link I18n.t("helpers.links.edit")
    fill_in Associate.human_attribute_name(:first_name), with: "Dav"
    click_button I18n.t("helpers.submit.associate.update")

    # Vérifier la redirection vers le show après édition
    associate = new_associate
    expect(page).to have_current_path(company_associate_path(associate.company, associate))
    expect(page).to have_content("Dav")
    expect(page).to have_content("Dupont")

    # Cliquer sur "Associés" dans la navigation de la société
    within("#company-navbar") do
      click_link "Associé(e)s"
    end

    # Supprimer le dernier associé
    page.accept_confirm do
      all(".card-footer .text-danger").last.click
    end
    expect(page).to have_no_content("Dav")
  end

  def properties_crud(current_company)
    visit company_properties_path(current_company)

    # Créer une nouvelle propriété
    click_link I18n.t("properties.index.new_link")
    fill_in Property.human_attribute_name(:address), with: "123 rue de la Mer"
    fill_in Property.human_attribute_name(:description), with: "Villa Demo"
    fill_in Property.human_attribute_name(:acquisition_date), with: "2023-10-15"
    fill_in Property.human_attribute_name(:acquisition_price), with: "150000"
    click_button I18n.t("helpers.submit.property.create")

    # Vérifier la redirection vers le show de la propriété
    property = Property.find_by(description: "Villa Demo")
    expect(page).to have_current_path(company_property_path(current_company, property))
    expect(page).to have_content("Villa Demo")
    expect(page).to have_content("123 rue de la Mer")

    # Modifier la propriété
    click_link I18n.t("helpers.links.edit")
    fill_in Property.human_attribute_name(:description), with: "Villa Modifiée"
    click_button I18n.t("helpers.submit.property.update")

    # Vérifier la redirection vers le show après édition
    expect(page).to have_current_path(company_property_path(current_company, property))
    expect(page).to have_content("Villa Modifiée")

    # Retour à la liste des propriétés via la navigation
    within("#company-navbar") do
      click_link "Biens immobiliers"
    end

    # Supprimer la dernière propriété
    page.accept_confirm do
      all(".card-footer .text-danger").last.click
    end
    expect(page).to have_no_content("Villa Modifiée")
  end

  def financial_operations_crud(current_company)
    visit company_financial_operations_path(current_company)

    # Créer une nouvelle opération financière
    click_link I18n.t("financial_operations.index.new_link")
    fill_in FinancialOperation.human_attribute_name(:label), with: "Recette août"
    fill_in FinancialOperation.human_attribute_name(:amount), with: "1200"
    fill_in FinancialOperation.human_attribute_name(:operation_date), with: "2023-10-15"

    select I18n.t("activerecord.attributes.financial_operation.categories.income"), from: FinancialOperation.human_attribute_name(:category)
    click_button I18n.t("helpers.submit.financial_operation.create")

    # Vérifier la redirection vers le show de l'opération
    operation = FinancialOperation.find_by(label: "Recette août")
    expect(page).to have_current_path(company_financial_operation_path(current_company, operation))
    expect(page).to have_content("Recette août")
    expect(page).to have_content("1 200,00 €")

    # Modifier l'opération
    click_link I18n.t("helpers.links.edit")
    fill_in FinancialOperation.human_attribute_name(:label), with: "Recette septembre"
    click_button I18n.t("helpers.submit.financial_operation.update")

    # Vérifier la redirection vers le show après édition
    expect(page).to have_current_path(company_financial_operation_path(current_company, operation))
    expect(page).to have_content("Recette septembre")

    # Retour à la liste des opérations via la navigation
    within("#company-navbar") do
      click_link "Opérations financières"
    end

    # Supprimer la dernière opération
    page.accept_confirm do
      all(".card-footer .text-danger").last.click
    end
    expect(page).to have_no_content("Loyer septembre")
  end

  def tenants_crud(current_company)
    visit company_tenants_path(current_company)

    # Créer un nouveau locataire
    click_link I18n.t("tenants.index.new_link")
    fill_in Tenant.human_attribute_name(:first_name), with: "Jean"
    fill_in Tenant.human_attribute_name(:last_name), with: "Martin"
    fill_in Tenant.human_attribute_name(:email), with: "jean.martin@example.com"
    click_button I18n.t("helpers.submit.tenant.create")

    # Vérifier la redirection vers le show du locataire
    tenant = Tenant.find_by(email: "jean.martin@example.com")
    expect(page).to have_current_path(company_tenant_path(current_company, tenant))
    expect(page).to have_content("Jean")
    expect(page).to have_content("Martin")
    expect(page).to have_content("jean.martin@example.com")

    # Modifier le locataire
    click_link I18n.t("helpers.links.edit")
    fill_in Tenant.human_attribute_name(:first_name), with: "Jean-Pierre"
    click_button I18n.t("helpers.submit.tenant.update")

    # Vérifier la redirection vers le show après édition
    expect(page).to have_current_path(company_tenant_path(current_company, tenant))
    expect(page).to have_content("Jean-Pierre")

    # Retour à la liste des locataires via la navigation
    within("#company-navbar") do
      click_link "Locataires"
    end

    # Supprimer le dernier locataire
    page.accept_confirm do
      all(".card-footer .link-danger").first.click
    end
    expect(page).to have_no_content("Jean-Pierre")
  end

  def general_meetings_crud(current_company)
    visit company_general_meetings_path(current_company)

    # Créer une nouvelle assemblée générale
    click_link I18n.t("general_meetings.index.new_link")
    fill_in GeneralMeeting.human_attribute_name(:title), with: "AG annuelle"
    fill_in GeneralMeeting.human_attribute_name(:date), with: "2023-12-01"
    fill_in GeneralMeeting.human_attribute_name(:minutes_text), with: "Approbation des comptes"
    click_button I18n.t("helpers.submit.general_meeting.create")

    # Vérifier la redirection vers le show de l'AG
    meeting = GeneralMeeting.find_by(title: "AG annuelle")
    expect(page).to have_current_path(company_general_meeting_path(current_company, meeting))
    expect(page).to have_content("AG annuelle")
    expect(page).to have_content("Approbation des comptes")

    # Modifier l'AG
    click_link I18n.t("helpers.links.edit")
    fill_in GeneralMeeting.human_attribute_name(:title), with: "AG extraordinaire"
    click_button I18n.t("helpers.submit.general_meeting.update")

    # Vérifier la redirection vers le show après édition
    expect(page).to have_current_path(company_general_meeting_path(current_company, meeting))
    expect(page).to have_content("AG extraordinaire")

    # Retour à la liste des AG via la navigation
    within("#company-navbar") do
      click_link "Assemblées générales"
    end

    # Supprimer la dernière AG
    page.accept_confirm do
      all(".card-footer .text-danger").last.click
    end
    expect(page).to have_no_content("AG extraordinaire")
  end

  scenario "Guide touristique" do
    Rails.application.load_seed
    # Seed completed: 1 admin users,5 companies, 15 associates, 20 properties, 10 tenants,
    #                 60 financial operations, 10 general meetings created.
    visit "/"
    current_company = Company.last
    visit company_path(current_company)
    associates_crud(current_company)
    properties_crud(current_company)
    financial_operations_crud(current_company)
    tenants_crud(current_company)
    general_meetings_crud(current_company)

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
