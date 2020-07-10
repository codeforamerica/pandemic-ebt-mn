require 'rails_helper'

describe ReviewChildBirthdayForm do
  before do
    @household = Household.create(is_eligible: :yes)
    @child = @household.children.create(dob: '1/1/2001')
    @valid_form = described_class.new(@household, { id: @child.id, dob_month: '12', dob_day: '10', dob_year: '2010' })

    @household2 = Household.create(is_eligible: :yes)
    @child2 = @household2.children.create(dob: '1/1/2001')
    @invalid_form = described_class.new(@household, { id: @child2.id, dob_month: '12', dob_day: '10', dob_year: '2010' })
  end

  after do
    @household.destroy!
  end

  describe '#save' do
    it 'updates the DOB' do
      form = @valid_form.dup
      form.save
      @household.reload
      @child.reload

      expect(@child.dob.day).to eq(10)
      expect(@child.dob.month).to eq(12)
      expect(@child.dob.year).to eq(2010)
    end

    it 'does not update when the child ID is not part of the household' do
      form = @invalid_form.dup
      form.save
      @household2.reload
      @child2.reload

      expect(@child2.dob).not_to eq(10)
      expect(@child2.dob.month).not_to eq(12)
      expect(@child2.dob.year).not_to eq(2010)
    end
  end
end
