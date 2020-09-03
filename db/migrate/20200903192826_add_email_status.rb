class AddEmailStatus < ActiveRecord::Migration[6.0]
  def change
    add_column :households, :denial_email_status, :integer, limit: 2, default: 0
    add_column :children, :denial_status, :integer, limit: 2, default: 0
  end
end
