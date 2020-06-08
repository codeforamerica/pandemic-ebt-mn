require 'rails_helper'

describe AddStudentForm do
  before do
    @household = Household.create(is_eligible: :yes)
    @valid_form = described_class.new(@household, { first_name: 'Jane', last_name: 'Smith', dob_month: '12', dob_day: '10', dob_year: '2010', school_registration_gender: 'F', school_attended_name: 'CFA Middle', school_attended_grade: '8' })
  end

  after do
    @household.destroy!
  end

  describe '#save' do
    it 'saves one child to the household' do
      form = @valid_form.dup
      form.valid?
      expect { form.save }.not_to change(Household, :count)
      expect { form.save }.to change { @household.children.count }.by(1)

      @household.reload
      @household.children.first

      expect(@household.children.first.first_name).to eq('Jane')
      expect(@household.children.first.dob.day).to eq(10)
      expect(@household.children.first.dob.month).to eq(12)
      expect(@household.children.first.dob.year).to eq(2010)
    end

    it 'saves the school org id to the database if we can match it' do
      form = @valid_form.dup
      form.school_attended_name = 'Alden - Conger Elementary'
      form.valid?
      form.save

      @household.reload
      @household.children.first

      expect(@household.children.first.school_attended_name).to eq('Alden - Conger Elementary')
      expect(@household.children.first.school_attended_id).to eq('10242002000')
    end

    it 'does not save an org id if the user enters a school not in the list' do
      form = @valid_form.dup
      form.school_attended_name = 'A School That Does Not Exist'
      form.valid?
      form.save

      @household.reload
      @household.children.first

      expect(@household.children.first.school_attended_name).to eq('A School That Does Not Exist')
      expect(@household.children.first.school_attended_id).to eq('')
    end
  end

  describe '#presence_of_dob_fields' do
    it 'is invalid if any dob field is not present' do
      form = @valid_form.dup
      form.dob_day = ''
      expect(form).not_to be_valid

      form = @valid_form.dup
      form.dob_month = ''
      expect(form).not_to be_valid

      form = @valid_form.dup
      form.dob_year = ''
      expect(form).not_to be_valid
    end

    it 'is valid if all dob fields are present' do
      form = @valid_form.dup
      expect(form).to be_valid
    end

    it 'only shows one dob error if any of the fields are blank' do
      form = @valid_form.dup
      form.dob_day = ''
      form.valid?
      expect(form.errors.count).to eq(1)
    end
  end

  describe '#validity_of_date' do
    it 'requires a real date' do
      form = @valid_form.dup
      form.dob_day = '31'
      form.dob_month = '2'
      form.dob_year = '1999'
      expect(form).not_to be_valid
    end
  end

  describe '#presence_of_school_registration_gender_field' do
    it 'is invalid if school registered gender is not present' do
      form = @valid_form.dup
      form.school_registration_gender = ''
      expect(form).not_to be_valid
    end

    it 'has a relevant error message' do
      form = @valid_form.dup
      form.school_registration_gender = ''
      form.valid?
      expect(form.errors.count).to eq(1)
      expect(form.errors.first[1]).to eq('Please fill in their gender.')
    end
  end

  describe '#presence_of_school_attended_name_field' do
    it 'is invalid if school name is not present' do
      form = @valid_form.dup
      form.school_attended_name = ''
      expect(form).not_to be_valid
    end

    it 'has a relevant error message' do
      form = @valid_form.dup
      form.school_attended_name = ''
      form.valid?
      expect(form.errors.count).to eq(1)
      expect(form.errors.first[1]).to eq('Please fill in their school.')
    end
  end

  describe '#presence_of_school_attended_grade_field' do
    it 'is invalid if school grade is not present' do
      form = @valid_form.dup
      form.school_attended_grade = ''
      expect(form).not_to be_valid
    end

    it 'is invalid if a bad school grade is entered' do
      form = @valid_form.dup
      form.school_attended_grade = '13'
      expect(form).not_to be_valid
    end

    it 'has a relevant error message' do
      form = @valid_form.dup
      form.school_attended_grade = ''
      form.valid?
      expect(form.errors.count).to eq(1)
      expect(form.errors.first[1]).to eq('Please fill in their grade.')
    end
  end
end
