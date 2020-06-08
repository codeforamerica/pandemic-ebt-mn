class Child < ApplicationRecord
  belongs_to :household

  scope :submitted, -> { includes(:household).where.not(households: { submitted_at: nil }) }
  scope :unsubmitted, -> { includes(:household).where(households: { submitted_at: nil }) }

  scope :submitted_after, ->(submitted_after_time) { submitted.where('households.submitted_at >= ?', submitted_after_time) }
  scope :submitted_before, ->(submitted_before_time) { submitted.where('households.submitted_at < ?', submitted_before_time) }

  scope :by_household, ->(hhid) { includes(:household).where(households: { id: hhid }) }

  def full_name
    "#{first_name} #{last_name}"
  end

  def csv_row
    [
      id,
      first_name,
      last_name,
      dob,
      school_registration_gender,
      school_attended_name,
      school_attended_grade,
      school_attended_id,
      School.breakfast_cep_for(school_attended_id),
      School.lunch_cep_for(school_attended_id),
      household.signature,
      household.mailing_street,
      household.mailing_street_2,
      household.mailing_city,
      'MN',
      household.mailing_zip_code,
      household.parent_first_name,
      household.parent_last_name,
      household.parent_dob,
      household.email_address,
      household.phone_number,
      household.language,
      household.submitted_at,
      household.application_experience,
      household.experiment_group,
      household.confirmation_code.to_s.delete('-')
    ]
  end

  def self.csv_headers
    %w[
      child_id
      student_first_name
      student_last_name
      student_dob
      student_gender
      student_school_name
      student_school_grade
      student_school_id
      student_school_breakfast_cep
      student_school_lunch_cep
      parent_signature
      mailing_street
      mailing_street_2
      mailing_city
      mailing_state
      mailing_zip_code
      parent_first_name
      parent_last_name
      parent_dob
      email_address
      phone_number
      language
      submitted_at
      application_experience
      experiment_group
      maxis_id
    ]
  end
end
