class Household < ApplicationRecord
  has_many :children

  enum is_eligible: { unfilled: 0, yes: 1, no: 2, dont_know: 3 }, _prefix: :is_eligible
  enum received_card: { unfilled: 0, yes: 1, no: 2 }, _prefix: :received_card
  enum application_experience: { unfilled: 0, good: 1, ok: 2, bad: 3 }, _suffix: true
  enum experiment_group: { unfilled: 0, ca_early: 1 }

  def confirmation_code
    children.order(:dob).first.suid.scan(/.{5}/).join('-')
  end

  def youngest_child
    children.order(:dob).last
  end
end
