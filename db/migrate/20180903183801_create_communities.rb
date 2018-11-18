class CreateCommunities < ActiveRecord::Migration[5.1]
  def change
    create_table :communities do |t|
      t.string :name, null: false
      t.text :location, null:false
      t.references :division, foreign_key: true
      t.timestamps
    end
  end
end
