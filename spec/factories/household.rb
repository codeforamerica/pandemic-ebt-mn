FactoryBot.define do
  factory :household do
    is_eligible { 1 }
    signature { Faker::Name.name }
    submitted_at { Faker::Time.backward(days: 14) }
    application_experience { %w[unfilled good bad ok][rand(4)] }
    language { I18n.available_locales[rand(I18n.available_locales.count)] }
    parent_first_name { Faker::Name.first_name }
    parent_last_name { Faker::Name.last_name }
    parent_dob { Faker::Date.in_date_period(year: 1970) }
    huid { Household.next_huid }

    trait :with_mailing_address do
      mailing_street { Faker::Address.unique.street_address }
      mailing_city { Faker::Address.city }
      mailing_zip_code { Faker::Address.zip }
      mailing_state { Faker::Address.state_abbr }
    end

    trait :unsubmitted do
      submitted_at { nil }
      signature { nil }
      huid { nil }
    end

    trait :submitted_today do
      submitted_at { 0.seconds.ago }
    end

    trait :submitted_yesterday do
      submitted_at { 24.hours.ago }
    end

    trait :with_community_organization do
      community_organization { 'USDR' }
      did_you_get_help { 'yes' }
    end
  end

  trait :with_email do
    email_address { Faker::Internet.email }
  end
end
