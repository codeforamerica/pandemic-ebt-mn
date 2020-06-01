class ParentForm < Form
  set_attributes_for :household, :parent_first_name, :parent_last_name, :parent_dob_day, :parent_dob_month, :parent_dob_year
  validates :parent_first_name, presence: { message: I18n.t('validations.first_name') }
  validates :parent_last_name, presence: { message: I18n.t('validations.last_name') }
  validate :presence_of_parent_dob_fields

  def save
    form_attributes = attributes_for(:household)
    attributes = {
      parent_first_name: form_attributes[:parent_first_name],
      parent_last_name: form_attributes[:parent_last_name],
      parent_dob: [form_attributes[:parent_dob_day], form_attributes[:parent_dob_month], form_attributes[:parent_dob_year]].join('/')
    }
    household.update(attributes)
  end

  protected

  def presence_of_parent_dob_fields
    %i[parent_dob_year parent_dob_month parent_dob_day].detect do |attr|
      errors.add(:dob, proc { I18n.t('validations.dob') }) if public_send(attr).blank?
    end
  end
end
