class ChangeFirstLastToFullNameToContacts < ActiveRecord::Migration[5.1]
  def change
    add_column :contacts, :name, :string
    Contact.update_all("name = first_name || ' ' || last_name")
    change_column :contacts, :name, :string, null: false

    remove_column :contacts, :first_name
    remove_column :contacts, :last_name
  end
end
