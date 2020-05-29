class ContactForm < Form
  set_attributes_for :household, :email_address, :phone_number
  validates :email_address, format: { with: URI::MailTo::EMAIL_REGEXP, message: proc { I18n.t('validations.email_address') },
                                      if: :email_address_present? }
  before_validation do
    self.phone_number = phone_number.gsub(/[^0-9]/, '')
  end
  validates_length_of :phone_number, is: 10, if: :phone_number_present?,
                                     message: I18n.t('validations.phone_number')

  def save
    attributes = attributes_for(:household)
    household.update(attributes)
  end

  private

  def email_address_present?
    email_address.present?
  end

  def phone_number_present?
    phone_number.present?
  end
end
