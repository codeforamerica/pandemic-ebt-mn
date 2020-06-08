require 'csv'
SCHOOL_LIST = CSV.read(
  Rails.root.join('config', 'schoollist.csv'),
  headers: true,
  converters: :all
).map(&:to_hash).freeze
