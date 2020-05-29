class AddPhoneNumberToHousehold < ActiveRecord::Migration[6.0]
  def change
    add_column :households, :phone_number, :string
  end
end
