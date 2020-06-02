require 'rails_helper'

RSpec.describe 'Autocompleting a school', type: :feature do
  before do
    visit '/'
    expect(page).to have_text 'Get help buying food while schools are closed'
    click_on 'Apply now'
    expect(page).to have_text "Here's how it works"
    click_on 'Continue'
    expect(page).to have_text 'Does your household use food benefits (SNAP/EBT)'
    click_on 'No'
    expect(page).to have_text 'Is the student able to receive free or reduced price meals'
    choose 'Yes'
    click_on 'Continue'
    expect(page).to have_text 'Add all the students in your house'
    click_on 'Add a student'
    expect(page).to have_text 'Add a student.'
    fill_in 'First name', with: 'Jane'
    fill_in 'Last name', with: 'Johnson'
    select 'January', from: 'Month'
    select '2', from: 'Day'
    select '2010', from: 'Year'
    choose 'Female'
  end

  describe 'Unknown school names' do
    it 'is cool with entering in a school name not in the database' do
      school_name = 'Some school that does not exist'
      fill_in 'What school did they attend during the 2019 - 2020 school year?', with: school_name
      select '8th grade', from: 'What grade were they in during the 2019 - 2020 school year?'
      click_on 'Continue'
      expect(Child.find_by(school_attended_name: school_name)).not_to be_nil
    end

    it 'does not save a school id in the database' do
      school_name = 'Some school that does not exist'
      fill_in 'What school did they attend during the 2019 - 2020 school year?', with: school_name
      select '8th grade', from: 'What grade were they in during the 2019 - 2020 school year?'
      click_on 'Continue'
      record = Child.find_by(school_attended_name: school_name)
      expect(record.school_attended_id).to be_nil
    end
  end

  describe 'Known school names' do
    it 'stores the school ID along with the school name' do
      school_id = 10002001000
      school_name = 'Hill City Elementary'
      fill_in 'What school did they attend during the 2019 - 2020 school year?', with: school_name
      select '8th grade', from: 'What grade were they in during the 2019 - 2020 school year?'
      click_on 'Continue'
      expect(Child.find_by(school_attended_name: school_name)).not_to be_nil
      expect(Child.find_by(school_attended_id: school_id)).not_to be_nil
    end
  end
end
