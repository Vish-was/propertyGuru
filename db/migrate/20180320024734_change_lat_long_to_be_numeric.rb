class ChangeLatLongToBeNumeric < ActiveRecord::Migration[5.1]
  def change
    change_column :lots, :latitude, :numeric
    change_column :lots, :longitude, :numeric
  end
end
