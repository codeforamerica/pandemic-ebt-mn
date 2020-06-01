class AddSchools < ActiveRecord::Migration[6.0]
  def change
    create_table :schools do |t|
      t.string :state_organization_id
      t.string :organization_name
      t.timestamps
    end
  end
end
