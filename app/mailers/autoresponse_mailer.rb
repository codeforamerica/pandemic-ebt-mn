class AutoresponseMailer
  def mail(to)
    client = Mailgun::Client.new(Rails.application.credentials.mailgun_api_key)
    msg =  {
      from: 'MN Pandemic EBT <no-reply@p-ebt.org>',
      to: to,
      subject: 'Email address is not monitored',
      text: text_body,
      html: html_body
    }
    client.send_message 'p-ebt.org', msg
  end

  def text_body
    <<~BODY
      This email address is not monitored. 

      Please visit https://mn.gov/dhs/p-ebt for more information about Pandemic EBT. 

      If you still have questions, email DHS.SNAP.SpecialProjects@state.mn.us

      **This is an automated message. Please do not reply to this message.**
    BODY
  end

  def html_body
    <<~BODY
      <html>
      <body>
      <p>
      This email address is not monitored. 
      </p>
      <p>
      Please visit <a href="https://mn.gov/dhs/p-ebt">mn.gov/dhs/p-ebt</a> for more information about Pandemic EBT. 
      </p>
      <p>
      If you still have questions, email <a href="mailto:DHS.SNAP.SpecialProjects@state.mn.us">DHS.SNAP.SpecialProjects@state.mn.us</a>
      </p>
      <p>
      **This is an automated message. Please do not reply to this message.**
      </p>
      </body>
      </html>
    BODY
  end
end
