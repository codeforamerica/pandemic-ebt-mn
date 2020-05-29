require 'rails_helper'

describe ContactForm do
  describe '#save' do
    it 'updates the existing household' do
      household = Household.create(is_eligible: :yes)
      form = described_class.new(household, { email_address: 'test@test.com', phone_number: '555-123-1234' })
      form.valid?
      form.save

      household.reload

      expect(household.email_address).to eq('test@test.com')
      expect(household.phone_number).to eq('5551231234')
    end

    it 'handles invalid phone number' do
      household = Household.create(is_eligible: :yes)
      form = described_class.new(household, { phone_number: '123-3323' })

      expect(form).not_to be_valid
      expect(form.errors.first[1]).to eq('Please enter a valid phone number.')
    end
  end
end
