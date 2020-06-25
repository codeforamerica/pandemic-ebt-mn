class AddCleanStateFieldToHousehold < ActiveRecord::Migration[6.0]
  def change
    add_column :households, :clean_state, :string
  end
end
