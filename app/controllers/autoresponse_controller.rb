class AutoresponseController < ActionController::Base
  skip_before_action :verify_authenticity_token

  def autoresponse
    sender = params['sender']
    AutoresponseMailer.new.mail(sender)
    render json: { email: sender }
  end
end
