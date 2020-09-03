class Child < ApplicationRecord
  belongs_to :household

  enum denial_status: { unknown: 0, denied: 1 }, _prefix: :denial_status

  scope :submitted, -> { includes(:household).where.not(households: { submitted_at: nil }) }
  scope :unsubmitted, -> { includes(:household).where(households: { submitted_at: nil }) }

  scope :submitted_after, ->(submitted_after_time) { submitted.where('households.submitted_at >= ?', submitted_after_time) }
  scope :submitted_before, ->(submitted_before_time) { submitted.where('households.submitted_at < ?', submitted_before_time) }

  scope :by_household, ->(hhid) { includes(:household).where(households: { id: hhid }) }

  def full_name
    "#{first_name} #{last_name}"
  end

  def maxis_id
    no_dash = household.confirmation_code.to_s.delete('-')
    case no_dash
    when '99000001'
      '99999991'
    when '99000002'
      '99999992'
    else
      no_dash
    end
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
      School.type_for(school_attended_id),
      School.formatted_org_id_for(school_attended_id),
      school_attended_id,
      School.breakfast_cep_for(school_attended_id),
      School.lunch_cep_for(school_attended_id),
      household.signature,
      household.did_you_get_help,
      household.community_organization,
      household.clean_street_1,
      household.clean_street_2,
      household.clean_city,
      household.clean_state,
      household.clean_zip_code,
      household.clean_coordinates&.y,
      household.clean_coordinates&.x,
      household.mailing_street,
      household.mailing_street_2,
      household.mailing_city,
      household.mailing_state,
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
      maxis_id
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
      student_school_type
      student_school_formatted_id
      student_school_id
      student_school_breakfast_cep
      student_school_lunch_cep
      parent_signature
      did_you_get_help
      community_organization
      clean_street
      clean_street_2
      clean_city
      clean_state
      clean_zip_code
      clean_latitude
      clean_longitude
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
