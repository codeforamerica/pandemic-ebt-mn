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
        label: name
      }
    end
  end

  def self.where(term)
    term ||= ''
    SCHOOL_LIST.select { |name| name.downcase.include?(term.downcase) }
  end
end
