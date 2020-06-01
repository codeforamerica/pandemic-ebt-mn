require 'rails_helper'

RSpec.describe 'Visiting page without locale', type: :feature do
  it 'switches language to default locale' do
    visit '/how'
    expect(URI.parse(current_url).path).to eq '/en/how'
  end
end
