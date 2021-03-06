require 'rails_helper'
require 'csv'

HEADERS = %w[ child_id student_first_name student_last_name student_dob student_gender student_school_name student_school_grade student_school_type student_school_formatted_id
              student_school_id student_school_breakfast_cep student_school_lunch_cep parent_signature did_you_get_help community_organization
              clean_street clean_street_2 clean_city clean_state clean_zip_code clean_latitude clean_longitude mailing_street mailing_street_2 mailing_city mailing_state mailing_zip_code parent_first_name
              parent_last_name parent_dob email_address phone_number language submitted_at application_experience experiment_group maxis_id ].freeze

RSpec.describe 'Exporting Children as CSV', type: :feature do
  def row_for_child(child)
    @csv_data.find { |r| r['child_id'] == child.id.to_s }
  end

  before(:all) do
    @output_file_name = Rails.root.join('tmp', 'all.csv')
    Child.delete_all
    Household.delete_all
    create_list(:child, 20)
    @unsubmitted_child = create(:child, household: create(:household, :unsubmitted))
    @child_with_email = create(:child, household_id: create(:household, :with_email).id)
    @child_with_mailing_address = create(:child, household_id: create(:household, :with_mailing_address).id)
    @child_from_today = create(:child, household: create(:household, :submitted_today))
    @child_from_yesterday = create(:child, household: create(:household, :submitted_yesterday))
    @child_with_double_quotes = create(:child, household: create(:household, clean_street_2: 'Apt "B"'))
    @child_at_matched_school = create(:child, household: create(:household), school_attended_name: 'Centennial Elementary', school_attended_id: '10280695000')
    @child_with_community_organization = create(:child, household: create(:household, :with_community_organization))
    @child_with_geocoded_address = create(:child, household: create(:household, :geocoded))
  end

  after(:all) do
    # prevent data leakage:
    Child.destroy_all
    Household.destroy_all
    File.delete(@output_file_name) if File.exist?(@output_file_name)
  end

  context 'when exporting last 7 days' do
    before(:all) do
      midnight_7_days_ago = DateTime.now.midnight - 7.days
      @child_from_midnight = create(:child, household: create(:household, submitted_at: DateTime.now.midnight))
      @child_from_midnight_7_days_ago = create(:child, household: create(:household, submitted_at: midnight_7_days_ago))
      @child_from_8_days_ago = create(:child, household: create(:household, submitted_at: DateTime.now - 8.days))
      @captured_stdout = `thor export:last_x_days 7`
      @csv_data = CSV.read(@output_file_name, headers: true)
    end

    it 'includes children created yesterday' do
      yesterday_row = row_for_child @child_from_yesterday
      expect(yesterday_row).not_to be_nil
    end

    it 'does not include children added today' do
      today_row = row_for_child @child_from_today
      expect(today_row).to be_nil
    end

    it 'does not include children added today at midnight' do
      today_row = row_for_child @child_from_midnight
      expect(today_row).to be_nil
    end

    it 'includes children added after midnight of the 7th day' do
      midnight_row = row_for_child @child_from_midnight_7_days_ago
      expect(midnight_row).not_to be_nil
    end

    it 'does not include children before 7 days ago' do
      child_from_8_days_ago_row = row_for_child @child_from_8_days_ago
      expect(child_from_8_days_ago_row).to be_nil
    end
  end

  context 'when exporting submitted children' do
    before(:all) do
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

    it 'Exports geocode data' do
      geocode_row = row_for_child @child_with_geocoded_address
      expect(geocode_row['clean_longitude']).to eq('-122.408363')
      expect(geocode_row['clean_latitude']).to eq('37.781712')
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
      expect(row['clean_street_2']).to eq(@child_with_double_quotes.household.clean_street_2)
    end

    it 'Exports parent info' do
      random_child_row = row_for_child @child_with_email
      expect(random_child_row['parent_first_name']).to eq(@child_with_email.household.parent_first_name)
      expect(random_child_row['parent_last_name']).to eq(@child_with_email.household.parent_last_name)
      expect(random_child_row['parent_dob']).to eq(@child_with_email.household.parent_dob.to_s)
    end

    it 'Exports community_organization' do
      kid_with_co = row_for_child @child_with_community_organization
      expect(kid_with_co['community_organization']).to eq(@child_with_community_organization.household.community_organization)
      expect(kid_with_co['did_you_get_help']).to eq('yes')
    end

    it 'Exports confirmation code without dashes' do
      random_child_row = row_for_child @child_with_email
      expect(random_child_row['maxis_id']).to match(/\d{8}/)
    end

    it 'Exports school information when matched' do
      matched_child_row = row_for_child @child_at_matched_school
      expect(matched_child_row['student_school_id']).to eq('10280695000')
      expect(matched_child_row['student_school_breakfast_cep']).to eq('Provision 2')
      expect(matched_child_row['student_school_lunch_cep']).to eq('Regular')
      expect(matched_child_row['student_school_type']).to eq('School')
      expect(matched_child_row['student_school_formatted_id']).to eq('0280-01-695')
    end

    it 'Exports blank school information when not matched' do
      random_child_row = row_for_child @child_with_email
      expect(random_child_row['student_school_id']).to be_nil
      expect(random_child_row['student_school_breakfast_cep']).to be_nil
      expect(random_child_row['student_school_lunch_cep']).to be_nil
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
