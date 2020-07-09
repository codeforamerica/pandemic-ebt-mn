class AutoresponseController < ApplicationController
  skip_before_action :http_authenticate
  skip_before_action :set_sentry_context
  skip_before_action :check_locale
  skip_around_action :switch_locale

  def autoresponse
    sender = params['sender']
    AutoresponseMailer.new.mail(sender)
    render json: { email: sender }
  end
end
