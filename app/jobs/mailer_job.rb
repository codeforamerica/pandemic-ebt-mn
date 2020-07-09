class MailerJob
  include SuckerPunch::Job

  def perform(household)
    ConfirmationMailer.new.mail(household)
  end
end
