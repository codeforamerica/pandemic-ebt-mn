class AddDefaultStateToHouseholds < ActiveRecord::Migration[6.0]
  def change
    Household.where(mailing_state: nil).update_all mailing_state: 'MN'
    change_column :households, :mailing_state, :string, limit: 2, null: false, default: 'MN'
  end
end
