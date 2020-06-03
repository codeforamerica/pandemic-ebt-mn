class ExtendLimitForSchoolId < ActiveRecord::Migration[6.0]
  def change
    change_column :children, :school_attended_id, :string, limit: 12
  end
end
