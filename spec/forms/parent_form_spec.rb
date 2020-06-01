require 'rails_helper'
require 'faker'

describe ParentForm do
  describe '#save' do
    before do
      @household = Household.create(is_eligible: :yes)
      @household_params = {
        parent_first_name: Faker::Name.first_name,
        parent_last_name: Faker::Name.last_name,
        parent_birthdate: Faker::Date.in_date_period(year: 1970)
      }
      @form = described_class.new(@household, @household_params)
    end

    it 'updates the existing household' do
      expect(@form).to be_valid

      @form.save
      @household.reload

      expect(@household.parent_first_name).to eq(@household_params[:parent_first_name])
      expect(@household.parent_last_name).to eq(@household_params[:parent_last_name])
      expect(@household.parent_birthdate).to eq(@household_params[:parent_birthdate])
    end

    it 'requires first name' do
      @form.parent_first_name = nil
      expect(@form).not_to be_valid
    end

    it 'requires last name' do
      @form.parent_last_name = nil
      expect(@form).not_to be_valid
    end

    it 'requires birthdate' do
      @form.parent_birthdate = nil
      expect(@form).not_to be_valid
    end
  end
end
