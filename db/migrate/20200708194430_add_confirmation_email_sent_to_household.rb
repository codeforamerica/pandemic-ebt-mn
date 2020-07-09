class AddConfirmationEmailSentToHousehold < ActiveRecord::Migration[6.0]
  def change
    add_column :households, :confirmation_email_sent, :boolean, default: false
  end
end
