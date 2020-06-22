class MakeLanguageThreeChars < ActiveRecord::Migration[6.0]
  def change
    change_column :households, :language, :string, limit: 3
  end
end
