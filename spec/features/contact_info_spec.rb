require 'rails_helper'

RSpec.describe 'Contact Info Journey', type: :feature do
  def start_application
    visit 'en/steps/eligible'
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
    fill_in 'What school did they attend during the 2019 - 2020 school year?', with: 'CFA High'
    select '8th grade', from: 'What grade were they in during the 2019 - 2020 school year?'
    click_on 'Continue'
    expect(page).to have_text 'Add all the students in your house'
    click_on 'Add a student'
    fill_in 'First name', with: 'Joe'
    fill_in 'Last name', with: 'Johnson'
    select 'June', from: 'Month'
    select '22', from: 'Day'
    select '2012', from: 'Year'
    choose 'Male'
    fill_in 'What school did they attend during the 2019 - 2020 school year?', with: 'CFA Middle'
    select '6th grade', from: 'What grade were they in during the 2019 - 2020 school year?'
    click_on 'Continue'
    expect(page).to have_text 'Jane Johnson'
    expect(page).to have_text 'Joe Johnson'
    click_on 'Continue'
    expect(page).to have_text 'Where should we mail your P-EBT card?'
    fill_in 'What is the street address?', with: '1006 Summit Ave'
    fill_in 'What is the unit or apartment (optional)?', with: 'Unit 2'
    fill_in 'What is the city?', with: 'St Paul'
    select 'MN', from: 'What is the state?'
    fill_in 'What is the ZIP code?', with: '55105'
    click_on 'Continue'
    expect(page).to have_text 'Just so you know'
    click_on 'Continue'
    expect(page).to have_text 'Add a parent or guardian'
    fill_in 'What\'s their first name?', with: 'Christine'
    fill_in 'What\'s their last name?', with: 'Johnson'
    select 'June', from: 'Month'
    select '22', from: 'Day'
    select '1984', from: 'Year'
    click_on 'Continue'
  end

  before do
    start_application
    visit '/en/steps/contact'
  end

  describe 'inputting invalid email' do
    it 'properly displays error messages' do
      expect(page).to have_text 'How can we contact you?'
      fill_in :form_email_address, with: 'bad-email'
      click_on 'Continue'
      expect(page).to have_text 'Please enter a valid email address'
    end
  end

  describe 'continuing with no email' do
    it 'continues without validation if nothing is entered' do
      expect(page).to have_text 'How can we contact you?'
      click_on 'Continue'
      expect(page).to have_text 'Review your information'
    end
  end

  describe 'inputting valid email' do
    it 'continues without validation if nothing is entered' do
      expect(page).to have_text 'How can we contact you?'
      fill_in :form_email_address, with: 'test@test.test'
      click_on 'Continue'
      expect(page).to have_text 'Review your information'
    end
  end
end
