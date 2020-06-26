class AddCleanCoordinatesToHousehold < ActiveRecord::Migration[6.0]
  def change
    add_column :households, :clean_coordinates, :point
  end
end
