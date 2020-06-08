class AddStudentForm < Form
  set_attributes_for :child, :first_name, :last_name, :dob_day, :dob_month, :dob_year, :school_registration_gender, :school_attended_name, :school_attended_id, :school_attended_grade
  validates_presence_of :first_name, message: proc { I18n.t('validations.first_name') }
  validates_presence_of :last_name, message: proc { I18n.t('validations.last_name') }
  validates_presence_of :school_registration_gender, message: proc { I18n.t('validations.gender') }
  validates_presence_of :school_attended_name, message: proc { I18n.t('validations.school_name') }
  validates :school_attended_grade, inclusion: { in: (1..12).map(&:to_s).append('K', 'PK'), message: proc { I18n.t('validations.school_grade') } }
  validate :presence_of_dob_fields
  validate :validity_of_date

  def save
    form_attributes = attributes_for(:child)
    attributes = {
      first_name: form_attributes[:first_name],
      last_name: form_attributes[:last_name],
      dob: [form_attributes[:dob_day], form_attributes[:dob_month], form_attributes[:dob_year]].join('/'),
      school_registration_gender: form_attributes[:school_registration_gender],
      school_attended_name: form_attributes[:school_attended_name],
      school_attended_grade: form_attributes[:school_attended_grade],
      school_attended_id: School.org_id_for(form_attributes[:school_attended_name])
    }
    household.children.create(attributes)
    household.save
  end

  private

  def validity_of_date
    Date.parse [@dob_day, @dob_month, @dob_year].join('/') if @dob_day.present? && @dob_month.present? && @dob_year.present?
  rescue ArgumentError
    errors.add(:dob, proc { I18n.t('validations.dob') })
  end

  def presence_of_dob_fields
    %i[dob_year dob_month dob_day].detect do |attr|
      errors.add(:dob, proc { I18n.t('validations.dob') }) if public_send(attr).blank?
    end
  end
end
