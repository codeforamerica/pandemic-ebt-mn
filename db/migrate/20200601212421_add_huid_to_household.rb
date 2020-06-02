class AddHuidToHousehold < ActiveRecord::Migration[6.0]
  def change
    add_column :households, :huid, :integer
    add_index :households, :huid, unique: true
  end
end
