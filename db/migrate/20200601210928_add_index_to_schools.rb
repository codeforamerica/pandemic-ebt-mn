class AddIndexToSchools < ActiveRecord::Migration[6.0]
  def change
    add_index :schools, :organization_name
    add_index :schools, :state_organization_id
  end
end
