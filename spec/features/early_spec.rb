require 'rails_helper'

RSpec.describe 'Early Screen', type: :feature do
  before do
    stub_const 'ENV', ENV.to_h.merge('COMING_SOON' => '1')
  end

  describe 'Early page' do
    it 'does show apply now when the environment variable is set' do
      visit '/early'
      expect(page).to have_link 'Apply now'
      expect(page).not_to have_text 'California'
      expect(page).not_to have_text 'CA'
    end
  end
end
