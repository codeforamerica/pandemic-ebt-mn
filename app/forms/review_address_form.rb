class ReviewAddressForm < Form
  set_attributes_for :household, :mailing_street, :mailing_street_2, :mailing_city, :mailing_zip_code, :mailing_state
  validates_presence_of :mailing_street, message: proc { I18n.t('validations.address') }
  validates :mailing_street_2, length: { maximum: 128, too_long: proc { I18n.t('validations.address_2') } }
  validates_presence_of :mailing_city, message: proc { I18n.t('validations.city') }
  validates :mailing_zip_code, format: { with: /\A\d{5}\z/, message: proc { I18n.t('validations.zip_code') } }
  validates :mailing_state, inclusion: { in: VALID_STATES, message: proc { I18n.t('validations.state') } }
  before_validation :strip_zip

  def save
    household.update(attributes_for(:household))
  end

  protected

  def strip_zip
    @mailing_zip_code.to_s.strip!
  end
end
