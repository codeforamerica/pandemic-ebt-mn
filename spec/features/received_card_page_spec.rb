require 'rails_helper'

RSpec.describe 'Journey', type: :feature do
  describe 'selecting yes on received card page' do
    it 'shows all done page' do
      visit root_path
      expect(page).to have_text 'Get help buying food while schools are closed'
      click_on 'Apply now'
      expect(page).to have_text "Here's how it works"
      click_on 'Continue'
      expect(page).to have_text 'Does your household currently get food benefits (SNAP/FS/EBT)'
      click_on 'Yes'
      expect(page).to have_text 'You’re all done'
    end
  end
end
