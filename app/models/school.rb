class School
  MAX_RESULTS = 3
  FIELD_NAME = 'Name'.freeze
  FIELD_SCHOOL_ID = 'stateorganizationid'.freeze
  FIELD_SCHOOL_CITY = 'Site City'.freeze
  FIELD_BREAKFAST_CEP = 'School Breakfast Program Partici'.freeze
  FIELD_LUNCH_CEP = 'Nat School Lunch Program Partici'.freeze
  FIELD_FORMATTED_ORG_ID = 'formattedOrganizationID'.freeze
  FIELD_SCHOOL_TYPE = 'recordType'.freeze

  def self.find_sorted_by_term(term)
    term ||= ''
    results = where(term)

    if term.blank?
      final = results.take(MAX_RESULTS)
    else
      prioritized = results.select { |name| name.downcase.start_with?(term.downcase) }
      others = results - prioritized
      final = prioritized.take(MAX_RESULTS)
      if final.length < MAX_RESULTS
        final += others.take(MAX_RESULTS - final.length)
      end
    end

    final.map do |name|
      {
        value: name,
        label: "#{name} - #{city_for(name)}"
      }
    end
  end

  def self.where(term)
    term ||= ''
    schools = SCHOOL_LIST.map { |row| row[FIELD_NAME] }
    schools.select { |name| name.downcase.include?(term.downcase) }
  end

  def self.org_id_for(school_name)
    school = SCHOOL_LIST.find { |row| row[FIELD_NAME].casecmp(school_name).zero? }
    school.nil? ? nil : school[FIELD_SCHOOL_ID]
  end

  def self.city_for(school_name)
    school = SCHOOL_LIST.find { |row| row[FIELD_NAME].casecmp(school_name).zero? }
    school.nil? ? nil : school[FIELD_SCHOOL_CITY]
  end

  def self.breakfast_cep_for(school_id)
    school = SCHOOL_LIST.find { |row| row[FIELD_SCHOOL_ID].to_s == school_id }
    school.nil? ? nil : school[FIELD_BREAKFAST_CEP]
  end

  def self.lunch_cep_for(school_id)
    school = SCHOOL_LIST.find { |row| row[FIELD_SCHOOL_ID].to_s == school_id }
    school.nil? ? nil : school[FIELD_LUNCH_CEP]
  end

  def self.formatted_org_id_for(school_id)
    school = SCHOOL_LIST.find { |row| row[FIELD_SCHOOL_ID].to_s == school_id }
    school.nil? ? nil : school[FIELD_FORMATTED_ORG_ID]
  end

  def self.type_for(school_id)
    school = SCHOOL_LIST.find { |row| row[FIELD_SCHOOL_ID].to_s == school_id }
    school.nil? ? nil : school[FIELD_SCHOOL_TYPE]
  end
end
