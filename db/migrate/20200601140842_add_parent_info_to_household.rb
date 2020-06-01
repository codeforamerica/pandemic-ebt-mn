class AddParentInfoToHousehold < ActiveRecord::Migration[6.0]
  def change
    add_column :households, :parent_first_name, :string
    add_column :households, :parent_last_name, :string
    add_column :households, :parent_dob, :date
  end
end
