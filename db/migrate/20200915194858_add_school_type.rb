class AddSchoolType < ActiveRecord::Migration[6.0]
  def change
    add_column :children, :school_attended_type, :integer, limit: 2, default: 0
  end
end
