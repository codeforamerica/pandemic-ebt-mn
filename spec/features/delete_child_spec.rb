require 'rails_helper'

RSpec.describe 'Deleting a child', type: :feature do
  describe 'Deleting a child' do
    it 'deletes the child from the household' do
      visit '/'
      expect(page).to have_text 'Get help buying food while schools are closed'
      click_on 'Apply now'
      expect(page).to have_text "Here's how it works"
      click_on 'Continue'
      expect(page).to have_text 'Does your household use food benefits (SNAP/EBT)'
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
      expect(page).to have_text 'Jane Johnson'
      click_on '(remove)'
      expect(page).not_to have_text 'Jane Johnson'
      expect(page).to have_text 'Child has been removed'
    end
  end
end
