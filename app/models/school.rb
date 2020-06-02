class School < ApplicationRecord
  def as_json(options = {})
    options[:methods] = %i[value label]
    super
  end

  def value
    organization_name
  end

  def label
    organization_name
  end
end
