# frozen_string_literal: true

class RenameDivisionDefaultToBuilderDefaultInContacts < ActiveRecord::Migration[5.1]
  def change
    rename_column :contacts, :division_default, :builder_default
  end
end
