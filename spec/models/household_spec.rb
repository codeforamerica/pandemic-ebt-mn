require 'rails_helper'

describe Household do
  it 'Sets HUID on save with submitted_at' do
    household = create(:household)
    household.reload
    expect(household.huid).to be_present
  end

  it 'Does not set HUID until submitted' do
    household = create(:household, :unsubmitted)
    household.reload
    expect(household.huid).not_to be_present
  end

  it 'Formats HUID correctly' do
    household = create(:household)
    expect(household.confirmation_code).to match(/99-\d{6}/)
  end
end
