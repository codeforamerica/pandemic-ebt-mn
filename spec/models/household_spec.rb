require 'rails_helper'

describe Household do
  it 'Formats HUID correctly' do
    household = create(:household)
    expect(household.confirmation_code).to match(/99-\d{6}/)
  end
end
