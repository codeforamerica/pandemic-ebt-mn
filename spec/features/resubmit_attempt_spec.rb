require 'rails_helper'

RSpec.describe 'Journey', type: :feature do
  describe 'Full journey with attempt to resubmit' do
    it 'blocks the user from resubmitting' do
      visit root_path
      expect(page).to have_text 'Get help buying food while schools are closed'
      click_on('Learn more', match: :first)
      expect(page).to have_text 'Information about P-EBT'
      visit root_path
      click_on 'Apply now'
      expect(page).to have_text "Here's how it works"
      click_on 'Continue'
      expect(page).to have_text 'Does your household use food benefits (SNAP/EBT)'
      click_on 'No'
      expect(page).to have_text 'Is the student able to receive free or reduced price meals'
      choose 'Yes'
      click_on 'Continue'
      expect(page).to have_text 'List all the students in your house'
      click_on 'Add a student'
      expect(page).to have_text 'Add a student.'
      fill_in 'First name', with: 'Jane'
      fill_in 'Last name', with: 'Johnson'
      select 'January', from: 'Month'
      select '2', from: 'Day'
      select '2010', from: 'Year'
      choose 'Public school'
      click_on 'Continue'
      expect(page).to have_text 'List all the students in your house'
      click_on 'Add a student'
      fill_in 'First name', with: 'Joe'
      fill_in 'Last name', with: 'Johnson'
      select 'June', from: 'Month'
      select '22', from: 'Day'
      select '2012', from: 'Year'
      choose 'Private school'
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
      expect(page).to have_text 'How can we contact you?'
      fill_in :form_email_address, with: 'test@test.com'
      click_on 'Continue'
      expect(page).to have_text 'Add a parent or guardian’s signature.'
      expect(page).to have_text 'Type your full legal name here to sign this form. By entering your name you agree you have been honest on this form.'
      fill_in 'form_signature', with: 'Julia Johnson'
      click_on 'Submit Application'
      expect(page).to have_text 'Your application is done!'
      click_on 'Good'
      expect(page).to have_text 'Thank you for your feedback!'
      visit mailing_address_steps_path
      click_on 'Continue'
      expect(page).to have_text 'Your application is done!'
    end
  end
end
