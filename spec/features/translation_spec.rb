require 'rails_helper'

RSpec.describe 'translation', type: :feature, js: true do
  it 'switches language to Spanish' do
    visit '/en'
    select 'Español'
    expect(page).to have_text 'Reciba ayuda para comprar comida mientras escuelas están cerradas.'
  end
end
