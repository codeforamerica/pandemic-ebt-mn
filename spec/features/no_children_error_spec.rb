require 'rails_helper'

RSpec.describe 'Journey', type: :feature do
  describe 'trying to continue without adding children' do
    it 'shows an error' do
      visit root_path
      click_on 'Apply now'
      expect(page).to have_text "Here's how it works"
      click_on 'Continue'
      expect(page).to have_text 'Did your household receive SNAP/FS/EBT food benefits or Minnesota\'s Family Investment Program (MFIP) benefits in March 2020?'
      click_on 'No'
      expect(page).to have_text 'Is the student able to receive free or reduced price meals'
      choose 'Yes'
      click_on 'Continue'
      expect(page).to have_text 'Add all the students in your house'
      click_on 'Continue'
      expect(page).to have_text 'Please add a student.'
    end
  end
end
