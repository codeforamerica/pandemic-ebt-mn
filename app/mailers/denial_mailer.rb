class DenialMailer
  def mail(household)
    return unless household.denial_email_status_pending?

    client = Mailgun::Client.new(Rails.application.credentials.mailgun_api_key)
    msg =  {
      from: 'MN Pandemic EBT <no-reply@p-ebt.org>',
      to: household.email_address,
      subject: 'P-EBT Benefits Appeal Reminder',
      text: text_body(household),
      html: html_body(household)
    }
    begin
      client.send_message 'p-ebt.org', msg
    rescue Mailgun::CommunicationError
      nil
    else
      household.update(denial_email_status: :sent)
    end
  end

  def text_body(household)
    <<~BODY
                    Date: September 17, 2020
      #{'      '}
                    Dear P-EBT Applicant: #{household.parent_first_name.upcase} #{household.parent_last_name.upcase}
      #{'      '}
                    Confirmation number: #{household.confirmation_code}
      #{'      '}
                    On September 3, 2020, the Notice of Denial of P-EBT benefits and how to appeal was e-mailed to this e-mail address with an initial deadline of September 14.  As a reminder, for those who have not yet submitted an appeal if you would like to appeal this decision, you must submit an appeal via a P-EBT Webform (https://edocs.mn.gov/forms/DHS-7330-ENG) by *September 18*, which is an extended deadline. The P-EBT appeal process is a secondary review of your application with additional information that you provide.
      #{'      '}
                    *For those who have submitted an appeal, there is no further action to take at this time.*
            #{'        '}
                    If appealing, applicants must provide verification of each child’s eligibility for free and reduced price meals. Appeals will not be accepted without verification.  Examples of documents to verify eligibility for P-EBT benefits during the 2019-2020 school year may include:
                    - The free and reduced-priced meal program enrollment letter with each child’s name#{' '}
                    - A letter from your school administrator validating each child’s enrollment in free or reduced-price meals
                    - A report card or other school enrollment documentation from your 2019-2020 enrolled school with each child’s name if your child attends a school where all children are certified for free or reduced-price school meals (a community eligibility school)
            #{'        '}
                    If eligibility for the $325 P-EBT benefit cannot be determined, the $100 Summer P-EBT benefit will not be issued.#{'  '}
            #{'        '}
                    To report a lost or stolen EBT or P-EBT card, call 888-997-2227 or visit https://www.ebtEDGE.com
            #{'        '}
                    To apply for SNAP, a monthly benefit that can help you buy food for your family, visit https://www.applymn.dhs.mn.gov
            #{'        '}
                    Translations for P-EBT
            #{'        '}
                    English
                    For assistance in a language other than English, please submit request at https://edocs.mn.gov/forms/DHS-7330-ENG
            #{'        '}
                    Somali
                    Haddaad rabtid in lagugu caawiyo af kale oo aan ahayn Ingriisi (English), soo buuxi foomkan ku yaal boggan https://edocs.mn.gov/forms/DHS-7330-ENG
            #{'        '}
                    Hmong#{' '}
                    Yog koj xav tau kev pab hais txog ntawm txhais lus los yog ntawv Hmoob, thov koj teb rov qab rau ntawm daim ntawv online: https://edocs.mn.gov/forms/DHS-7330-ENG
            #{'        '}
                    Arabic
                  للمساعدة في لغة غير الانجليزية ، يرجى التقديم من خلال#{'  '}
                    https://edocs.mn.gov/forms/DHS-7330-ENG
            #{'        '}
                    Russian
                    Для получения помощи на языке, отличном от английского, пожалуйста, отправьте запрос по
                    https://edocs.mn.gov/forms/DHS-7330-ENG
            #{'        '}
                    Dlya polucheniya pomoshchi na yazyke, otlichnom ot angliyskogo, otprav'te zapros na stranitse#{' '}
                    https://edocs.mn.gov/forms/DHS-7330-ENG
            #{'        '}
                    Spanish
                    Si, tiene preguntas acerca de P-EBT por favor llene el formulario P-EBT HELP FORM y se le respondera en su idioma.
                    https://edocs.mn.gov/forms/DHS-7330-ENG
            #{'        '}
                    If you need free help interpreting this notice, call the number below for your language.
            #{'        '}
                    ያስተውሉ፡ ይህንን ዶኩመንት ለመተርጎም እርዳታ የሚፈልጉ ከሆነ፡ የጉዳዮን ሰራተኛ ይጠይቁ ወይም በሰልክ ቁጥር 1-844-217-3547 ይደውሉ። — Amharic
            #{'        '}
                    اللغة العربيةملاحظة: يحتوي هذا الإشعار على معلومات هامة حول ميزاتك. إذا أردت مساعدة مجانية لترجمة هذه الوثيقة، اطلب ذلك من مشرفك أو اتصل على الرقم 0377 - 358 - 800 - 1. — Arabic
            #{'        '}
                    သတိ။ ဤစာရွက်စာတမ်းအားအခမဲ့ဘာသာပြန်ပေးခြင်း အကူအညီလိုအပ်ပါက၊ သင့်လူမှုရေးအလုပ်သမား အားမေးမြန်း ခြင်းသို့မဟုတ် 1-844-217-3563 ကိုခေါ်ဆိုပါ။ — Burmese
            #{'        '}
                    請注意，如果您需要免費協助傳譯這份文件，請告訴您的工作人員或撥打 1-844-217-3564 — Cantonese
            #{'        '}
                    Attention. Si vous avez besoin d’une aide gratuite pour interpréter le présent document, demandez à votreagent chargé du traitement de cas ou appelez le 1-844-217-3548. — French
            #{'        '}
                    Thov ua twb zoo nyeem. Yog hais tias koj xav tau kev pab txhais lus rau tsab ntaub ntawv no pub dawb, ces nug koj tus neeg lis dej num los sis hu rau 1-888-486-8377. — Hmong
            #{'        '}
                    ပၥ်သူၣ်ပၥ်သးဘၣ်တက့ၢ်.ဖဲနမ့ၢ်လိၣ်ဘၣ်တၢ်မၤစၢၤကလီလၢတၢ်ကကျိးထံဝဲဒၣ်လံၥ်တီလံၥ်မီတခါအံၤန့ၣ်,သံကွၢ်ဘၣ်ပှၤဂ့ၢ်ဝီအပှၤမၤစၢၤတၢ်လၢနဂီၢ်မ့တမ့ၢ်ကိးဘၣ် 1-844-217-3549 တက့ၢ်. — Karen
            #{'        '}
                    កំណត់សំគាល់ ។ បេីអ្នកតូ្រវការជំនួយក្នុងការបកប្រឯកសារនេះដេាយៗតគិតឪថៃ្ឆឆ សូមសួរអ្នកកាន់សំណុំរឿង របសអ្នក បទហៅទូរស័ឮមកលខេ 1-888-468-3787 ។ — Khmer
            #{'        '}
                    알려드립니다. 이 문서에 대한 이해를 돕기 위해 무료로 제공되는 도움을 받으시려면 담당자에 게 문의하시거나 1-844-217-3565으로 연락하십시오. — Korean
            #{'        '}
                    ໂປຣດຊາບ. ຖ້າຫາກ ທ່ານຕ້ອງການການຊ່ວຍເຫຼືອໃນການແປເອກະສານນີ້ຟຣີ, ຈ່ ົງຖາມພະນ ັກງານກ 􀅗າກ ັ ບການຊ່ວຍເຫຼືອ ຂອງທ່ານ ຫຼື ໂທຣໄປທ່ ີ 1-888-487-8251. — Lao
            #{'        '}
                    Hubachiisa. Dokumentiin kun bilisa akka siif hiikamu gargaarsa hoo feete, hojjettoota kee gaafadhu ykn afaan ati dubbattuuf bilbilli 1-888-234-3798. — Oromo
            #{'        '}
                    Внимание: если вам нужна бесплатная помощь в устном переводе данного документа, обратитесь к своему социальному работнику или позвоните по телефону 1-888-562-5877. — Russian
            #{'        '}
                    Digniin. Haddii aad u baahantahay caawimaad lacag-la’aan ah ee tarjumaadda qoraalkan, hawlwadeenkaaga weydiiso ama wac lambarka 1-888-547-8829. — Somali
            #{'        '}
                    Atención. Si desea recibir asistencia gratuita para interpretar este documento, comuníquese con su trabajador o llame al 1-888-428-3438. — Spanish
            #{'        '}
                    Chú ý. Nếu quý vị cần được giúp đỡ dịch tài liệu này miễn phí, xin gọi nhân viên xã hội của quý vị hoặc gọi số 1-888-554-8759. — Vietnamese#{'      '}
            #{'        '}
                    **This is an automated message. Please do not reply to this message.**
    BODY
  end

  def children_text_list(household)
    list = []
    household.children.where(denial_status: :denied).each do |child|
      list << "- #{child.first_name.upcase} #{child.last_name.upcase} | Born: #{child.dob.strftime('%m/%d/%Y')} | School: #{child.school_attended_name} #{child.school_attended_id}"
    end
    list.join("\n")
  end

  def html_body(household)
    <<~BODY
                  <html>
                  <body>
                  <p>Date: September 17, 2020</p>
      #{'      '}
                  <p>Dear P-EBT Applicant: #{household.parent_first_name.upcase} #{household.parent_last_name.upcase}</p>
      #{'      '}
                  <p>Confirmation number: #{household.confirmation_code}</p>
            #{'      '}
                  <p>On September 3, 2020, the Notice of Denial of P-EBT benefits and how to appeal was e-mailed to this e-mail address with an initial deadline of September 14.  As a reminder, for those who have not yet submitted an appeal if you would like to appeal this decision, you must submit an appeal via a <a href="https://edocs.mn.gov/forms/DHS-7330-ENG">P-EBT Webform</a> by <strong>September 18</strong>, which is an extended deadline. The P-EBT appeal process is a secondary review of your application with additional information that you provide.</p>#{' '}
            #{'      '}
                  <p><strong>For those who have submitted an appeal, there is no further action to take at this time.</strong></p>#{'  '}
            #{'            '}
                  <p>If appealing, applicants must provide verification of each child’s eligibility for free and reduced price meals. Appeals will not be accepted without verification.  Examples of documents to verify eligibility for P-EBT benefits during the 2019-2020 school year may include:</p>
                  <ul>
                  <li>The free and reduced-priced meal program enrollment letter with each child’s name</li>
                  <li>A letter from your school administrator validating each child’s enrollment in free or reduced-price meals</li>
                  <li>A report card or other school enrollment documentation from your 2019-2020 enrolled school with each child’s name if your child attends a school where all children are certified for free or reduced-price school meals(a community eligibility school)</li>
                  </ul>
      #{'      '}
                  <p>If eligibility for the $325 P-EBT benefit cannot be determined, the $100 Summer P-EBT benefit will not be issued.</p>
            #{'      '}
                  <p>To report a lost or stolen EBT or P-EBT card, call 888-997-2227 or visit <a href="https://www.ebtEDGE.com">https://www.ebtEDGE.com</a></p>
            #{'      '}
                  <p>To apply for SNAP, a monthly benefit that can help you buy food for your family, visit <a href="https://www.applymn.dhs.mn.gov">https://www.applymn.dhs.mn.gov</a></p>
            #{'      '}
                  <p><b>Translations for P-EBT</b></p>
            #{'      '}
                  <p>English<br>
                  For assistance in a language other than English, please submit request at <a href="https://edocs.mn.gov/forms/DHS-7330-ENG">https://edocs.mn.gov/forms/DHS-7330-ENG</a></p>
            #{'      '}
                  <p>Somali<br>
                  Haddaad rabtid in lagugu caawiyo af kale oo aan ahayn Ingriisi (English), soo buuxi foomkan ku yaal boggan <a href="https://edocs.mn.gov/forms/DHS-7330-ENG">https://edocs.mn.gov/forms/DHS-7330-ENG</a></p>
            #{'      '}
                  <p>Hmong<br>
                  Yog koj xav tau kev pab hais txog ntawm txhais lus los yog ntawv Hmoob, thov koj teb rov qab rau ntawm daim ntawv online: <a href="https://edocs.mn.gov/forms/DHS-7330-ENG">https://edocs.mn.gov/forms/DHS-7330-ENG</a></p>
            #{'      '}
                  <p>Arabic<br>
                  للمساعدة في لغة غير الانجليزية ، يرجى التقديم من خلال#{'  '}
                  <a href="https://edocs.mn.gov/forms/DHS-7330-ENG">https://edocs.mn.gov/forms/DHS-7330-ENG</a></p>
            #{'      '}
                  <p>Russian<br>
                  Для получения помощи на языке, отличном от английского, пожалуйста, отправьте запрос по<br>
                  <a href="https://edocs.mn.gov/forms/DHS-7330-ENG">https://edocs.mn.gov/forms/DHS-7330-ENG</a></p>
            #{'      '}
                  <p>Dlya polucheniya pomoshchi na yazyke, otlichnom ot angliyskogo, otprav'te zapros na stranitse <br>
                  <a href="https://edocs.mn.gov/forms/DHS-7330-ENG">https://edocs.mn.gov/forms/DHS-7330-ENG</a></p>
            #{'      '}
                  <p>Spanish<br>
                  Si, tiene preguntas acerca de P-EBT por favor llene el formulario P-EBT HELP FORM y se le respondera en su idioma.<br>
                  <a href="https://edocs.mn.gov/forms/DHS-7330-ENG">https://edocs.mn.gov/forms/DHS-7330-ENG</a></p>
            #{'      '}
                  <p>If you need free help interpreting this notice, call the number below for your language.</p>
            #{'      '}
                  <p>ያስተውሉ፡ ይህንን ዶኩመንት ለመተርጎም እርዳታ የሚፈልጉ ከሆነ፡ የጉዳዮን ሰራተኛ ይጠይቁ ወይም በሰልክ ቁጥር 1-844-217-3547 ይደውሉ። — Amharic</p>
            #{'      '}
                  <p>
                  اللغة العربيةملاحظة: يحتوي هذا الإشعار على معلومات هامة حول ميزاتك. إذا أردت مساعدة مجانية لترجمة هذه الوثيقة، اطلب ذلك من مشرفك أو اتصل على الرقم 0377 - 358 - 800 - 1. Arabic#{' '}
                  </p>
      #{'      '}
                  <p>သတိ။ ဤစာရွက်စာတမ်းအားအခမဲ့ဘာသာပြန်ပေးခြင်း အကူအညီလိုအပ်ပါက၊ သင့်လူမှုရေးအလုပ်သမား အားမေးမြန်း ခြင်းသို့မဟုတ် 1-844-217-3563 ကိုခေါ်ဆိုပါ။ — Burmese</p>
            #{'      '}
                  <p>請注意，如果您需要免費協助傳譯這份文件，請告訴您的工作人員或撥打 1-844-217-3564 — Cantonese</p>
            #{'      '}
                  <p>Attention. Si vous avez besoin d’une aide gratuite pour interpréter le présent document, demandez à votreagent chargé du traitement de cas ou appelez le 1-844-217-3548. — French</p>
            #{'      '}
                  <p>Thov ua twb zoo nyeem. Yog hais tias koj xav tau kev pab txhais lus rau tsab ntaub ntawv no pub dawb, ces nug koj tus neeg lis dej num los sis hu rau 1-888-486-8377. — Hmong</p>
            #{'      '}
                  <p>ပၥ်သူၣ်ပၥ်သးဘၣ်တက့ၢ်.ဖဲနမ့ၢ်လိၣ်ဘၣ်တၢ်မၤစၢၤကလီလၢတၢ်ကကျိးထံဝဲဒၣ်လံၥ်တီလံၥ်မီတခါအံၤန့ၣ်,သံကွၢ်ဘၣ်ပှၤဂ့ၢ်ဝီအပှၤမၤစၢၤတၢ်လၢနဂီၢ်မ့တမ့ၢ်ကိးဘၣ် 1-844-217-3549 တက့ၢ်. — Karen</p>
            #{'      '}
                  <p>កំណត់សំគាល់ ។ បេីអ្នកតូ្រវការជំនួយក្នុងការបកប្រឯកសារនេះដេាយៗតគិតឪថៃ្ឆឆ សូមសួរអ្នកកាន់សំណុំរឿង របសអ្នក បទហៅទូរស័ឮមកលខេ 1-888-468-3787 ។ — Khmer</p>
            #{'      '}
                  <p>알려드립니다. 이 문서에 대한 이해를 돕기 위해 무료로 제공되는 도움을 받으시려면 담당자에 게 문의하시거나 1-844-217-3565으로 연락하십시오. — Korean</p>
            #{'      '}
                  <p>ໂປຣດຊາບ. ຖ້າຫາກ ທ່ານຕ້ອງການການຊ່ວຍເຫຼືອໃນການແປເອກະສານນີ້ຟຣີ, ຈ່ ົງຖາມພະນ ັກງານກ 􀅗າກ ັ ບການຊ່ວຍເຫຼືອ ຂອງທ່ານ ຫຼື ໂທຣໄປທ່ ີ 1-888-487-8251. — Lao</p>
            #{'      '}
                  <p>Hubachiisa. Dokumentiin kun bilisa akka siif hiikamu gargaarsa hoo feete, hojjettoota kee gaafadhu ykn afaan ati dubbattuuf bilbilli 1-888-234-3798. — Oromo</p>
            #{'      '}
                  <p>Внимание: если вам нужна бесплатная помощь в устном переводе данного документа, обратитесь к своему социальному работнику или позвоните по телефону 1-888-562-5877. — Russian</p>
            #{'      '}
                  <p>Digniin. Haddii aad u baahantahay caawimaad lacag-la’aan ah ee tarjumaadda qoraalkan, hawlwadeenkaaga weydiiso ama wac lambarka 1-888-547-8829. — Somali</p>
            #{'      '}
                  <p>Atención. Si desea recibir asistencia gratuita para interpretar este documento, comuníquese con su trabajador o llame al 1-888-428-3438. — Spanish</p>
            #{'      '}
                  <p>Chú ý. Nếu quý vị cần được giúp đỡ dịch tài liệu này miễn phí, xin gọi nhân viên xã hội của quý vị hoặc gọi số 1-888-554-8759. — Vietnamese</p>#{'      '}
            #{'      '}
                  <p>**This is an automated message. Please do not reply to this message.**</p>
                  </body>
                  </html>
    BODY
  end

  def children_html_list(household)
    list = []
    household.children.where(denial_status: :denied).each do |child|
      list << "<li>#{child.first_name.upcase} #{child.last_name.upcase} | Born: #{child.dob.strftime('%m/%d/%Y')} | School: #{child.school_attended_name} #{child.school_attended_id}</li>"
    end
    "<ul>#{list.join("\n")}</ul>"
  end
end
