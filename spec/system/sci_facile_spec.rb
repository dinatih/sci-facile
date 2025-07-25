require 'rails_helper'

RSpec.describe "SCI Facile", type: :system do
  scenario "Public access to the homepage" do
    visit "/"
    sleep 20.seconds
    expect(page).to have_content("Welcome to the Application!")
  end
end
