# frozen_string_literal: true

class AddBuilderIdToContacts < ActiveRecord::Migration[5.1]
  def change
    add_reference :contacts, :builder, index: true
  end
end
