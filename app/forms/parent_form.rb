class MailingAddressForm < Form
  set_attributes_for :household, :parent_first_name, :parent_last_name, :dob_day, :dob_month, :dob_year
  validates :parent_first_name, presence: { message: I18n.t('validations.first_name') }
  validates :parent_first_name, presence: { message: I18n.t('validations.last_name') }
  validate :presence_of_dob_fields

  def save
    form_attributes = attributes_for(:household)
    attributes = {
      first_name: form_attributes[:parent_first_name],
      last_name: form_attributes[:parent_last_name],
      parent_dob: [form_attributes[:dob_day], form_attributes[:dob_month], form_attributes[:dob_year]].join('/')
    }
    household.update(attributes)
  end

  protected

  def presence_of_dob_fields
    %i[dob_year dob_month dob_day].detect do |attr|
      errors.add(:dob, proc { I18n.t('validations.dob') }) if public_send(attr).blank?
    end
  end
end
