require 'rails_helper'
require 'faker'

describe MailingAddressForm do
  describe '#save' do
    before do
      @household = Household.create(is_eligible: :yes)
      @form = described_class.new(@household, { mailing_street: '1006 Summit Ave', mailing_street_2: 'Unit 3', mailing_city: 'St Paul',
                                                mailing_zip_code: '55105', mailing_state: 'MN' })
    end

    it 'updates the existing household' do
      @form.valid?
      @form.save

      @household.reload

      expect(@household.mailing_street).to eq('1006 Summit Ave')
      expect(@household.mailing_street_2).to eq('Unit 3')
      expect(@household.mailing_city).to eq('St Paul')
      expect(@household.mailing_zip_code).to eq('55105')
      expect(@household.mailing_state).to eq('MN')
    end

    it 'is valid without address 2 line' do
      @form.mailing_street_2 = nil
      expect(@form).to be_valid
    end

    it 'is valid with address 2 line' do
      expect(@form).to be_valid
    end

    it 'is not valid if address 2 is too long' do
      @form.mailing_street_2 = Faker::String.random(length: 129)
      expect(@form).not_to be_valid
      expect(@form.errors.first[1]).to eq('Please enter a shorter unit or apartment.')
    end

    it 'validates zip codes' do
      @form.mailing_zip_code = 'not a zip code'
      expect(@form).not_to be_valid
    end

    it 'allows out of state zip codes' do
      form = described_class.new(@household, { mailing_street: '1600 Pennsylvania Avenue NW', mailing_city: 'Washington D.C.',
                                               mailing_zip_code: '20500', mailing_state: 'DC' })

      expect(form).to be_valid
    end

    it 'trims zip codes' do
      @form.mailing_zip_code = '55105 '
      expect(@form).to be_valid

      @form.save
      expect(@household.mailing_zip_code).to eq('55105')
    end

    it 'requires a state' do
      @form.mailing_state = ''
      expect(@form).not_to be_valid
    end
  end
end
