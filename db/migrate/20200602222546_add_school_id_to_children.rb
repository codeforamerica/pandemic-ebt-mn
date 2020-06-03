class AddSchoolIdToChildren < ActiveRecord::Migration[6.0]
  def change
    add_column :children, :school_attended_id, :string, limit: 11
  end
end
