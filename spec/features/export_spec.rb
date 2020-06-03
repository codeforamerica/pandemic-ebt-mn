require 'rails_helper'
require 'csv'

HEADERS = %w[ child_id student_first_name student_last_name student_dob student_gender
              student_school_name student_school_id student_school_grade student_school_breakfast_cep student_school_lunch_cep
              parent_signature mailing_street mailing_street_2 mailing_city mailing_state mailing_zip_code parent_first_name
              parent_last_name parent_dob email_address phone_number language submitted_at application_experience experiment_group maxis_id ].freeze

RSpec.describe 'Exporting Children as CSV', type: :feature do
  def row_for_child(child)
    @csv_data.find { |r| r['child_id'] == child.id.to_s }
  end

  before(:all) do
    Child.delete_all
    Household.delete_all
    create_list(:child, 20)
    @unsubmitted_child = create(:child, household: create(:household, :unsubmitted))
    @child_with_email = create(:child, household_id: create(:household, :with_email).id)
    @child_with_mailing_address = create(:child, household_id: create(:household, :with_mailing_address).id)
    @child_from_today = create(:child, household: create(:household, :submitted_today))
    @child_from_yesterday = create(:child, household: create(:household, :submitted_yesterday))
    @child_with_breakfast_cep = create(:child,
                                       household_id: create(:household, :with_email).id,
                                       school_attended_name: 'Reach Programs',
                                       school_attended_id: '616051010000')
    @child_with_lunch_cep = create(:child,
                                   household_id: create(:household, :with_email).id,
                                   school_attended_name: 'St. Mary\s Mission',
                                   school_attended_id: '310038001000')
    @child_with_breakfast_p2 = create(:child,
                                      household_id: create(:household, :with_email).id,
                                      school_attended_name: 'Crossroads Montessori',
                                      school_attended_id: '10625465000')
    @child_with_lunch_p2 = create(:child,
                                  household_id: create(:household, :with_email).id,
                                  school_attended_name: 'Friendship Academy of Fine Arts Charter',
                                  school_attended_id: '74079010000')
    @child_with_non_cep_school = create(:child,
                                  household_id: create(:household, :with_email).id,
                                  school_attended_name: 'Rum River South',
                                  school_attended_id: '526079020000')
    @child_with_double_quotes = create(:child, household: create(:household, mailing_street_2: 'Apt "B"'))
  end

  after(:all) do
    # prevent data leakage:
    Child.destroy_all
    Household.destroy_all
  end

  context 'when exporting submitted children' do
    before(:all) do
      @output_file_name = Rails.root.join('tmp', 'all.csv')

      File.delete(@output_file_name) if File.exist?(@output_file_name)

      @captured_stdout = `thor export:children`
    end

    before do
      @csv_data = CSV.read(@output_file_name, headers: true)
    end

    it 'Has the proper headers' do
      expect(@csv_data.headers).to eq(HEADERS)
    end

    it 'Outputs the same number of columns in the rows as the header' do
      expect(@csv_data.map(&:length)).to all(eq(@csv_data.headers.length))
    end

    it 'Shows a confirmation message on the console' do
      expect(@captured_stdout).to have_text('EXPORT COMPLETE')
    end

    it 'Creates a file called /tmp/all.csv' do
      expect(File).to exist(@output_file_name)
    end

    it 'Exports all children' do
      expect(@csv_data.count).to eq(Child.submitted.count)
    end

    it 'Exports the language' do
      expect(@csv_data.map { |r| r['language'] }).to all(be_present)
    end

    it 'Exports email address if present' do
      email_row = row_for_child @child_with_email
      expect(@child_with_email.household.email_address).to be_present
      expect(email_row['email_address']).to eq(@child_with_email.household.email_address)
    end

    it 'Only exports submitted children' do
      unsubmitted_child_row = row_for_child @unsubmitted_child
      expect(unsubmitted_child_row).to eq(nil)
    end

    it 'Escapes double quotes' do
      row = row_for_child @child_with_double_quotes
      expect(row['mailing_street_2']).to eq(@child_with_double_quotes.household.mailing_street_2)
    end

    it 'Exports parent info' do
      random_child_row = row_for_child @child_with_email
      expect(random_child_row['parent_first_name']).to eq(@child_with_email.household.parent_first_name)
      expect(random_child_row['parent_last_name']).to eq(@child_with_email.household.parent_last_name)
      expect(random_child_row['parent_dob']).to eq(@child_with_email.household.parent_dob.to_s)
    end

    it 'Exports no CEP information when a school does not match' do
      child_row = row_for_child @child_with_email
      expect(child_row['student_school_breakfast_cep']).to be_empty
      expect(child_row['student_school_lunch_cep']).to be_empty
    end

    it 'Exports matching school CEP information if breakfast matches' do
      child_row = row_for_child @child_with_breakfast_cep
      expect(child_row['student_school_breakfast_cep']).to eq('Community Eligibility Provision')
    end

    it 'Exports matching school CEP information if lunch matches' do
      child_row = row_for_child @child_with_lunch_cep
      expect(child_row['student_school_lunch_cep']).to eq('Community Eligibility Provision')
    end

    it 'Exports matching school P2 information if breakfast matches' do
      child_row = row_for_child @child_with_breakfast_p2
      expect(child_row['student_school_breakfast_cep']).to eq('Provision 2')
    end

    it 'Exports matching school P2 information if lunch matches' do
      child_row = row_for_child @child_with_lunch_p2
      expect(child_row['student_school_lunch_cep']).to eq('Provision 2')
    end

    it 'Only Exports information if a school is CEP or P2' do
      child_row = row_for_child @child_with_non_cep_school
      expect(child_row['student_school_lunch_cep']).to eq('')
      expect(child_row['student_school_breakfast_cep']).to eq('')
    end
  end

  context 'when exporting children by date' do
    it 'includes only children for yesterday when yesterday is exported' do
      output_file_name = Rails.root.join('tmp', 'all.csv')
      File.delete(output_file_name) if File.exist?(output_file_name)
      captured_stdout = `thor export:children -a '#{Date.current - 1.day}' -b  '#{Date.current}'`

      expect(captured_stdout).to have_text('EXPORT COMPLETE')

      @csv_data = CSV.read(output_file_name, headers: true)
      expect(row_for_child(@child_from_today)).to be_nil
      expect(row_for_child(@child_from_yesterday)).not_to be_nil
    end
  end
end
