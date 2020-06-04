class RemoveSchoolIdFromChildren < ActiveRecord::Migration[6.0]
  def change
    remove_column :children, :school_attended_id
  end
end
