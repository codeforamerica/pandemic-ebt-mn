require 'thor'
require 'csv'
require './config/environment' # Load Rails

class Import < Thor
  desc 'denials FILE', 'Import children from the database to FILE (defaults to tmp/denials.csv)'
  def denials(file_name = Rails.root.join('tmp', 'denials.csv'))
    counter = 0
    CSV.foreach(file_name, headers: true) do |row|
      if (child = Child.find_by_id(row["child_id"]))
        school_attended_id = row["student_school_id"] == "NA" ? "" : row["student_school_id"]
        child.update_attributes(denial_status: :denied, school_attended_name: row["student_school_name"], school_attended_id: school_attended_id)
        child.household.update_attributes(denial_email_status: :pending)
        counter += 1
      end
    end
    puts "Updated #{counter} children records"
  end
end
