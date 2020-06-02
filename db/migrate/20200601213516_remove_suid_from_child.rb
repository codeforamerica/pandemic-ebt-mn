class RemoveSuidFromChild < ActiveRecord::Migration[6.0]
  def change
    remove_index :children, :suid
    remove_column :children, :suid, :string
  end
end
