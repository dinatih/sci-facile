begin
  require "faker"
  Faker::Config.locale = "fr"
rescue LoadError
  # Faker n'est pas installé (probablement en production), on ignore
end
