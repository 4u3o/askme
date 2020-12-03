class ChangeBackgroundColorInUsers < ActiveRecord::Migration[6.0]
  change_column_default :users, :background_color, '#005a55'
  change_column :users, :background_color, :string, limit: 7
end
