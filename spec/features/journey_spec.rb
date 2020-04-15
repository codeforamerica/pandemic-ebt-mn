require 'rails_helper'

RSpec.feature "Journey", type: :feature do
  describe "Full journey" do
    it "should run the full journey" do
      visit "/"
      expect(page).to have_text "Get money to buy healthy food while schools are closed."
      click_on "Sign up now"
      expect(page).to have_text "Here's how it works:"
      click_on "Continue"
      expect(page).to have_text "Is your child able to receive free or reduced price meals"
      choose "Yes"
      click_on "Continue"
      expect(page).to have_text "Have you received a P-EBT card?"
      click_on "No"
      expect(page).to have_text "Tell us about your child"
      fill_in "First name", with: "Jane"
      fill_in "Last name", with: "Johnson"
      select "January", from: "Month"
      select "2", from: "Day"
      select "2010", from: "Year"
      click_on "Add another child"
      expect(page).to have_text "Jane Johnson"
      fill_in "First name", with: "Joe"
      fill_in "Last name", with: "Johnson"
      select "January", from: "Month"
      select "2", from: "Day"
      select "2010", from: "Year"
      click_on "Continue"
      expect(page).to have_text "Add the name of one parent or guardian"
      fill_in "First name", with: "Julia"
      fill_in "Last name", with: "Johnson"
      click_on "Continue"
      expect(page).to have_text "What address are you registered at the school with"
      fill_in "What is the street address?", with: "123 Elm Street"
      fill_in "What is the city?", with: "Oakland"
      fill_in "What is the ZIP code?", with: "90123"
      choose "No, use a different address for mail"
      click_on "Continue"
      expect(page).to have_text "Success!"
    end
  end
end
