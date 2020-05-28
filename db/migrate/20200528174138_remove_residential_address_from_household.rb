class RemoveResidentialAddressFromHousehold < ActiveRecord::Migration[6.0]
  def change
    remove_column :households, :residential_street
    remove_column :households, :residential_city
    remove_column :households, :residential_zip_code
    remove_column :households, :has_mailing_address
    remove_column :households, :residential_street_2
    remove_column :households, :same_residential_address
    remove_column :households, :registered_homeless
  end
end
