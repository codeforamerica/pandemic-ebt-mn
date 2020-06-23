class AddStateToHousehold < ActiveRecord::Migration[6.0]
  def change
    add_column :households, :mailing_state, :string, limit: 2
  end
end
