class School
  NAME_HEADER = 'name'.freeze
  LUNCH_CEP_HEADER = 'lunch_cep'.freeze
  BREAKFAST_CEP_HEADER = 'breakfast_cep'.freeze

  def self.find_sorted_by_term(term)
    filtered_results = where(term)
    results = filtered_results.sort_by { |_org_id, info| info[NAME_HEADER] }
    results = Hash[results[0..2]]
    results.map do |r|
      {
        id: r.first,
        value: r.last[NAME_HEADER],
        label: r.last[NAME_HEADER]
      }
    end
  end

  def self.find_id_by_name(org_name)
    school_array = SCHOOL_LIST.find { |_org_id, info| info[NAME_HEADER] == org_name } || []
    school_array.first
  end

  def self.where(term)
    term ||= ''
    SCHOOL_LIST.select { |_org_id, info| info[NAME_HEADER].downcase.include?(term.downcase) }
  end

  def self.breakfast_cep_for_school(org_id)
    school = SCHOOL_LIST[org_id]
    school.nil? ? '' : school[BREAKFAST_CEP_HEADER]
  end

  def self.lunch_cep_for_school(org_id)
    school = SCHOOL_LIST[org_id]
    school.nil? ? '' : school[LUNCH_CEP_HEADER]
  end
end
