class ReviewChildBirthdayForm < Form
  set_attributes_for :child, :dob_day, :dob_month, :dob_year, :dob, :id
  validate :presence_of_dob_fields
  validate :validity_of_date

  def save
    form_attributes = attributes_for(:child)
    attributes = {
      dob: [form_attributes[:dob_day], form_attributes[:dob_month], form_attributes[:dob_year]].join('/')
    }
    child = Child.find(form_attributes[:id])
    return if child.household != household

    child.update(attributes)
  end

  private

  def date_in_future?(dob)
    dob.present? && dob.future?
  end

  def validity_of_date
    dob = Date.parse [@dob_day, @dob_month, @dob_year].join('/') if @dob_day.present? && @dob_month.present? && @dob_year.present?
    errors.add(:dob, proc { I18n.t('validations.dob') }) if date_in_future?(dob)
  rescue ArgumentError
    errors.add(:dob, proc { I18n.t('validations.dob') })
  end

  def presence_of_dob_fields
    %i[dob_year dob_month dob_day].detect do |attr|
      errors.add(:dob, proc { I18n.t('validations.dob') }) if public_send(attr).blank?
    end
  end
end
