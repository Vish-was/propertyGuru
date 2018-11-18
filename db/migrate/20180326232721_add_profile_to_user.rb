class AddProfileToUser < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :profile, :jsonb, null: false, default: '{}'
  end
end
