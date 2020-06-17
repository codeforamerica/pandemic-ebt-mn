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

    it 'handles an invalid phone number' do
      household = Household.create(is_eligible: :yes)
      form = described_class.new(household, { phone_number: 'asdf' })

      expect(form).not_to be_valid
      expect(form.errors.first[1]).to eq('Please enter a valid phone number.')
    end

    it 'handles a too short phone number' do
      household = Household.create(is_eligible: :yes)
      form = described_class.new(household, { phone_number: '123-3323' })

      expect(form).not_to be_valid
      expect(form.errors.first[1]).to eq('Please enter a valid phone number.')
    end

    it 'handles phone numbers with alphanumeric characters' do
      household = Household.create(is_eligible: :yes)
      form = described_class.new(household, { phone_number: 'asdf8135551212' })

      expect(form).not_to be_valid
      expect(form.errors.first[1]).to eq('Please enter a valid phone number.')
    end

    it 'handles phone numbers with dashes and parenthesis' do
      household = Household.create(is_eligible: :yes)
      form = described_class.new(household, { phone_number: '(813) 555-1212' })

      expect(form).to be_valid
    end

    it 'rejects phone numbers that start with a 0' do
      household = Household.create(is_eligible: :yes)
      form = described_class.new(household, { phone_number: '(013) 555-1212' })

      expect(form).not_to be_valid
    end

    it 'rejects phone numbers that start with a 1' do
      household = Household.create(is_eligible: :yes)
      form = described_class.new(household, { phone_number: '(113) 555-1212' })

      expect(form).not_to be_valid
    end
  end
end
