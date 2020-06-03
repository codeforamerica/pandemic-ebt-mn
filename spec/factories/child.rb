FactoryBot.define do
  factory :child do
    household
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    dob { Faker::Date.between(from: 5.years.ago, to: 17.years.ago) }
    school_registration_gender { %w[F M][rand(2)] }
    school_attended_name { Faker::Company.name + ' School' }
    school_attended_grade { Faker::Number.between(from: 1, to: 12).to_s }
  end
end
