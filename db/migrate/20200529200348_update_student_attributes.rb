class UpdateStudentAttributes < ActiveRecord::Migration[6.0]
  def change
    remove_column :children, :school_type
    add_column :children, :school_registration_gender, :string, limit: 1
    add_column :children, :school_attended_name, :string
    add_column :children, :school_attended_grade, :string, limit: 2
  end
end
