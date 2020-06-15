require 'rails_helper'

describe 'Child' do
  describe '#full_name' do
    it 'returns the full name' do
      child = Child.new({ first_name: 'Jane', last_name: 'Smith', dob: '31/12/1999' })
      expect(child.full_name).to eq('Jane Smith')
    end
  end

  describe '#maxis_id' do
    it 'returns an un-dashed ID from household huid' do
      household = create(:household)
      household.huid = 123
      child = create(:child, household: household)
      expect(child.maxis_id).to eq('99000123')
    end

    it 'returns a modified ID when household huid is 1 or 2' do
      household = create(:household)
      household.huid = 1
      child = create(:child, household: household)
      expect(child.maxis_id).to eq('99999991')

      household2 = create(:household)
      household2.huid = 2
      child2 = create(:child, household: household2)
      expect(child2.maxis_id).to eq('99999992')
    end
  end
end
