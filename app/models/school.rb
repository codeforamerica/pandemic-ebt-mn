class School
  MAX_RESULTS = 3

  def self.find_sorted_by_term(term)
    term = '' if term.nil?
    results = where(term)
    if term.present?
      results = results.sort do |r1, r2|
        if r1.downcase.starts_with?(term.downcase)
          -1
        elsif r2.downcase.starts_with?(term.downcase)
          1
        else
          r1 <=> r2
        end
      end
    end
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
