class CreatePlanRooms < ActiveRecord::Migration[5.1]
  def change
    create_table :plan_rooms do |t|
      t.string :name, null:false
      t.attachment :image
      t.string :type, null:false
      t.timestamps
    end
  end
end
