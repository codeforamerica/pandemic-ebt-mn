class School
  MAX_RESULTS = 3

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
    schools = SCHOOL_LIST.map { |row| row['Name'] }
    schools.select { |name| name.downcase.include?(term.downcase) }
  end

  def self.org_id_for(school_name)
    school = SCHOOL_LIST.find { |row| row['Name'].casecmp(school_name).zero? }
    return '' if school.nil?

    school['stateorganizationid']
  end

  def self.city_for(school_name)
    school = SCHOOL_LIST.find { |row| row['Name'].casecmp(school_name).zero? }
    return '' if school.nil?

    school['Site City']
  end
end
