class ConfirmationMailer
  def mail(household)
    client = Mailgun::Client.new(Rails.application.credentials.mailgun_api_key)
    msg =  {
      from: 'MN Pandemic EBT <no-reply@p-ebt.org>',
      to: household.email_address,
      subject: 'We received your application',
      text: text_body(household),
      html: html_body(household)
    }
    client.send_message 'p-ebt.org', msg
    household.update(confirmation_email_sent: true)
  end

  def text_body(household)
    <<~BODY
      We received your application for Pandemic EBT. If approved,
      you will receive your P-EBT card within 30 days of application.
      If you have any questions, please visit https://mn.gov/dhs/p-ebt#{' '}

      Confirmation number: ##{household.confirmation_code}
      Application status: in review

      **This is an automated message. Please do not reply to this message.**
    BODY
  end

  def html_body(household)
    <<~BODY
                  <html>
                  <body>
                  <p>
                  We received your application for Pandemic EBT. If approved, you will receive your P-EBT card within 30 days of application.
                  If you have any questions, please visit <a href="https://mn.gov/dhs/p-ebt">mn.gov/dhs/p-ebt</a>
                  </p>#{' '}
            #{'  '}
                  <p>
                  Confirmation number: <b>##{household.confirmation_code}</b><br>
                  Application status: <b>in review</b>
                  </p>
      #{'      '}
                  <p>
                  **This is an automated message. Please do not reply to this message.**
                  </p>
                  </body>
                  </html>
    BODY
  end
end
