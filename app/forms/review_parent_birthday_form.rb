class ReviewParentBirthdayForm < Form
  set_attributes_for :household, :parent_dob_day, :parent_dob_month, :parent_dob_year, :parent_dob
  validate :presence_of_parent_dob_fields
  validate :validity_of_date

  def save
    form_attributes = attributes_for(:household)
    attributes = {
      parent_dob: [form_attributes[:parent_dob_day], form_attributes[:parent_dob_month], form_attributes[:parent_dob_year]].join('/')
    }
    household.update(attributes)
  end

  protected

  def date_in_future?(dob)
    dob.present? && dob.future?
  end

  def validity_of_date
    dob = Date.parse [@parent_dob_day, @parent_dob_month, @parent_dob_year].join('/') if @parent_dob_day.present? && @parent_dob_month.present? && @parent_dob_year.present?
    errors.add(:parent_dob, proc { I18n.t('validations.dob') }) if date_in_future?(dob)
  rescue ArgumentError
    errors.add(:parent_dob, proc { I18n.t('validations.dob') })
  end

  def presence_of_parent_dob_fields
    %i[parent_dob_year parent_dob_month parent_dob_day].detect do |attr|
      errors.add(:parent_dob, proc { I18n.t('validations.dob') }) if public_send(attr).blank?
    end
  end
end
