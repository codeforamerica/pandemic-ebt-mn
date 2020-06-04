class RemoveReceivedCardFromHousehold < ActiveRecord::Migration[6.0]
  def change
    remove_column :households, :received_card, :integer, default: 0
  end
end
