class School
  def self.find_sorted_by_term(term)
    filtered_results = where(term)
    results = filtered_results.sort_by { |_org_id, school_name| school_name }
    results = Hash[results[0..2]]
    results.map do |r|
      {
        id: r.first,
        value: r.last,
        label: r.last
      }
    end
  end

  def self.find_id_by_name(org_name)
    school_array = SCHOOL_LIST.find { |_org_id, school_name| school_name == org_name } || []
    school_array.first
  end

  def self.where(term)
    term ||= ''
    SCHOOL_LIST.select { |_org_id, school_name| school_name.downcase.include?(term.downcase) }
  end
end
