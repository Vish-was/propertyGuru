class RenameDefaultToDivisionDefaultInContacts < ActiveRecord::Migration[5.1]
  def change
    rename_column :contacts, :default, :division_default
  end
end
