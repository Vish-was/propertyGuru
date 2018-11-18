class CreateContacts < ActiveRecord::Migration[5.1]
  def change
    create_table :contacts do |t|
      t.string :first_name, null: false
      t.string :last_name, null: false
      t.string :phone
      t.string :email, null: false
      t.string :title
      t.boolean :default, null: false, default: false
      t.references :division, foreign_key: true

      t.timestamps
    end
  end
end
