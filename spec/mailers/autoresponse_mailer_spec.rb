require 'rails_helper'

RSpec.describe AutoresponseMailer do
  it 'calls the API' do
    allow_any_instance_of(Mailgun::Client).to receive(:send_message).and_return(nil)

    described_class.new.mail('test@example.com')
  end
end
