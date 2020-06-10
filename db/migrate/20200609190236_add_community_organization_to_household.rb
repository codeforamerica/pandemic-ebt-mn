class AddCommunityOrganizationToHousehold < ActiveRecord::Migration[6.0]
  def change
    add_column :households, :community_organization, :string
    add_column :households, :did_you_get_help, :integer, limit: 2, default: 0
  end
end
