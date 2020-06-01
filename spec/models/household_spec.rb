require 'rails_helper'

describe Household do
  describe '#confirmation_code' do
    it 'displays the formatted suid of the oldest child' do
      older_child = Child.new({ first_name: 'Jane', last_name: 'Smith', dob: '31/12/1999', school_registration_gender: 'F', school_attended_name: 'CFA Middle', school_attended_grade: '8', suid: '70CFAOLDERCHILDSUID9' })
      younger_child = Child.new({ first_name: 'Joe', last_name: 'Smith', dob: '01/01/2000', school_registration_gender: 'M', school_attended_name: 'CFA Elementary', school_attended_grade: '5', suid: '70CFAOLDERCHILDSUID8' })
      household = described_class.new
      household.children = [younger_child, older_child]
      household.save!
      expect(household.confirmation_code).to eq('70CFA-OLDER-CHILD-SUID9')
    end
  end

  describe '#youngest_child' do
    it 'returns the youngest child' do
      older_child = Child.new({ first_name: 'Jane', last_name: 'Smith', dob: '31/12/1999', school_registration_gender: 'F', school_attended_name: 'CFA Middle', school_attended_grade: '8', suid: '70CFAOLDERCHILDSUID9' })
      younger_child = Child.new({ first_name: 'Joe', last_name: 'Smith', dob: '01/01/2000', school_registration_gender: 'M', school_attended_name: 'CFA Elementary', school_attended_grade: '5', suid: '70CFAOLDERCHILDSUID8' })
      household = described_class.new
      household.children = [younger_child, older_child]
      household.save!
      expect(household.youngest_child.first_name).to eq('Joe')
    end
  end
end
