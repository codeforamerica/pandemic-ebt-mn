require 'rails_helper'

RSpec.describe ConfirmationMailer do
  it 'calls the API and updates the database' do
    expect_any_instance_of(Mailgun::Client).to receive(:send_message).and_return(nil)

    hh = Household.new(email_address: 'test@example.com')
    described_class.new.mail(hh)
    expect(hh.confirmation_email_sent).to be_truthy
  end
end
