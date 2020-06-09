require 'rails_helper'

RSpec.describe 'Journey', type: :feature do
  describe 'Full journey' do
    it 'runs the full journey' do
      visit root_path
      expect(page).to have_text 'Get help buying food while schools are closed'
      click_on('Learn more', match: :first)
      expect(page).to have_text 'Information about P-EBT'
      visit '/'
      click_on 'Apply now'
      expect(page).to have_text "Here's how it works"
      click_on 'Continue'
      expect(page).to have_text 'Does your household currently get food benefits (SNAP/FS/EBT)'
      click_on 'No'
      expect(page).to have_text 'Is the student able to receive free or reduced price meals'
      choose 'Yes'
      click_on 'Continue'
      expect(page).to have_text 'Add all the students in your house'
      click_on 'Add a student'
      expect(page).to have_text 'Add a student.'
      fill_in 'First name', with: 'Jane'
      fill_in 'Last name', with: 'Johnson'
      select 'January', from: 'Month'
      select '2', from: 'Day'
      select '2010', from: 'Year'
      choose 'Female'
      fill_in 'What school did they attend during the 2019 - 2020 school year?', with: 'CFA High'
      select '8th grade', from: 'What grade were they in during the 2019 - 2020 school year?'
      click_on 'Continue'
      expect(page).to have_text 'Add all the students in your house'
      click_on 'Add a student'
      fill_in 'First name', with: 'Joe'
      fill_in 'Last name', with: 'Johnson'
      select 'June', from: 'Month'
      select '22', from: 'Day'
      select '2012', from: 'Year'
      choose 'Male'
      fill_in 'What school did they attend during the 2019 - 2020 school year?', with: 'CFA Middle'
      select '6th grade', from: 'What grade were they in during the 2019 - 2020 school year?'
      click_on 'Continue'
      expect(page).to have_text 'Jane Johnson'
      expect(page).to have_text 'Joe Johnson'
      click_on 'Continue'
      expect(page).to have_text 'Where should we mail your P-EBT card?'
      fill_in 'What is the street address?', with: '1006 Summit Ave'
      fill_in 'What is the unit or apartment (optional)?', with: 'Unit 2'
      fill_in 'What is the city?', with: 'St Paul'
      fill_in 'What is the ZIP code?', with: '55105'
      click_on 'Continue'
      expect(page).to have_text 'Just so you know'
      click_on 'Continue'
      expect(page).to have_text 'Add a parent or guardian'
      fill_in 'What\'s their first name?', with: 'Christine'
      fill_in 'What\'s their last name?', with: 'Johnson'
      select 'June', from: 'Month'
      select '22', from: 'Day'
      select '1984', from: 'Year'
      click_on 'Continue'
      expect(page).to have_text 'How can we contact you?'
      fill_in 'What is your email address? (optional)', with: Faker::Internet.email
      fill_in 'What is your phone number? (optional)', with: '555-123-1234'
      click_on 'Continue'
      expect(page).to have_text 'Add a parent or guardian’s signature.'
      expect(page).to have_text 'Type your full legal name here to sign this form. By entering your name you agree you have been honest on this form.'
      fill_in 'form_signature', with: 'Julia Johnson'
      click_on 'Submit Application'
      expect(page).to have_text 'Your application is done!'
      expect(page).not_to have_text 'GET ME SOME CSV!!!'
      click_on 'Good'
      expect(page).to have_text 'Thank you for your feedback!'
    end
  end
end
