require 'thor'
require './config/environment' # Load Rails

class Clean < Thor
  desc 'addresses', 'Cleans mailing addresses using the SmartyStreets API'
  def addresses
    cleaner = AddressCleaner.new
    counter = 0
    Household.submitted.where(cleaned_address: false).each do |hh|
      cleaner.run(hh)
      counter += 1
    end
    puts "CLEANER COMPLETE! Ran on #{counter} addresses."
  end
end
