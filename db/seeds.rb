# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

if Rails.env.production?
  puts "Seeding is disabled in production for safety."
  exit
end

AdminUser.destroy_all

FactoryBot.create(:admin_user, email: 'admin@sci-facile.com')
puts "Seed completed: #{AdminUser.count} admin_users created."
