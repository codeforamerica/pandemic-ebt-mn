require 'rails_helper'
require 'faker'

describe ParentForm do
  describe '#save' do
    before do
      @household = Household.create(is_eligible: :yes)
      @dob = Faker::Date.in_date_period(year: 1970)
      @household_params = {
        parent_first_name: Faker::Name.first_name,
        parent_last_name: Faker::Name.last_name,
        parent_dob_year: @dob.year,
        parent_dob_month: @dob.month,
        parent_dob_day: @dob.day
      }
      @form = described_class.new(@household, @household_params)
    end

    it 'updates the existing household' do
      expect(@form).to be_valid

      @form.save
      @household.reload

      expect(@household.parent_first_name).to eq(@household_params[:parent_first_name])
      expect(@household.parent_last_name).to eq(@household_params[:parent_last_name])
      expect(@household.parent_dob).to eq(@dob)
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
      @form.parent_dob_day = nil
      expect(@form).not_to be_valid
    end
  end
end
