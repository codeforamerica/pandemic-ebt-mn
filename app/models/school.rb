class School
  MAX_RESULTS = 3

  def self.find_sorted_by_term(term)
    results = where(term)
    results.take(MAX_RESULTS).map do |name|
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
