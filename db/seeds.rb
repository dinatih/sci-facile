# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

if Rails.env.production?
  puts "Seeding is disabled in production for safety."
  exit
end

# Clear existing data
AdminUser.destroy_all
Company.destroy_all
Associate.destroy_all
Property.destroy_all
Tenant.destroy_all
FinancialOperation.destroy_all
GeneralMeeting.destroy_all

FactoryBot.create(:admin_user, email: 'admin@sci-facile.com')

# Create 5 companies with full data
5.times do
  company = FactoryBot.create(:company, :complete)

    # Add properties with tenants
    2.times do
      FactoryBot.create(:property, :apartment, :with_tenant, company: company)
    end

    # Add financial operations
    3.times do
      FactoryBot.create(:financial_operation, :rental_income, company: company)
      FactoryBot.create(:financial_operation, :expense, company: company)
    end

    # Add general meetings
    FactoryBot.create(:general_meeting, :annual, company: company)
    FactoryBot.create(:general_meeting, :extraordinary, company: company)
end

puts "Seed completed: #{AdminUser.count} admin users,#{Company.count} companies, #{Associate.count} associates, #{Property.count} properties, #{Tenant.count} tenants, #{FinancialOperation.count} financial operations, #{GeneralMeeting.count} general meetings created."
