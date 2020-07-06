class AddDefaultStateToHouseholds < ActiveRecord::Migration[6.0]
  def up
    Household.where(mailing_state: nil).update_all mailing_state: 'MN'
    change_column :households, :mailing_state, :string, limit: 2, null: false, default: 'MN'
  end

  def down
    Household.where(mailing_state: nil).update_all mailing_state: 'MN'
    change_column :households, :mailing_state, :string, limit: 2, null: true
  end
end
