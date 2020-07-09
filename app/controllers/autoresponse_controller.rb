class AutoresponseController < ActionController::Base
  def autoresponse
    sender = params['sender']
    AutoresponseMailer.new.mail(sender)
    render json: { email: sender }
  end
end
