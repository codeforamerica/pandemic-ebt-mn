require 'rails_helper'
require 'csv'

HEADERS = %w[ suid household_id student_first_name student_last_name student_dob student_gender student_school_name student_school_id
              student_school_grade parent_signature mailing_street mailing_street_2 mailing_city mailing_state mailing_zip_code
              parent_first_name parent_last_name parent_dob email_address phone_number language submitted_at application_experience
              confirmation_code ].freeze

RSpec.describe 'Exporting Children as CSV', type: :feature do
  def row_for_child(child)
    @csv_data.find { |r| r['suid'] == child.suid }
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
  end

  after(:all) do
    # prevent data leakage:
    Child.destroy_all
    Household.destroy_all
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

  context 'when exporting submitted children' do
    before(:all) do
      @output_file_name = Rails.root.join('tmp', 'all.csv')

      File.delete(@output_file_name) if File.exist?(@output_file_name)

      @captured_stdout = `thor export:children`
    end

    before do
      @csv_data = CSV.read(@output_file_name, headers: true)
    end

    it 'Shows a confirmation message on the console' do
      expect(@captured_stdout).to have_text('EXPORT COMPLETE')
    end

    it 'Creates a file called /tmp/all.csv' do
      expect(File).to exist(@output_file_name)
    end

    it 'Outputs the same number of columns in the rows as the header' do
      expect(@csv_data.map(&:length)).to all(eq(@csv_data.headers.length))
    end

    it 'Exports all children' do
      expect(@csv_data.count).to eq(Child.submitted.count)
    end

    it 'Has the proper headers' do
      expect(@csv_data.headers).to eq(HEADERS)
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

    it 'Exports parent info' do
      random_child_row = row_for_child @child_with_email
      expect(random_child_row['parent_first_name']).to eq(@child_with_email.household.parent_first_name)
      expect(random_child_row['parent_last_name']).to eq(@child_with_email.household.parent_last_name)
      expect(random_child_row['parent_dob']).to eq(@child_with_email.household.parent_dob.to_s)
    end
  end
end
