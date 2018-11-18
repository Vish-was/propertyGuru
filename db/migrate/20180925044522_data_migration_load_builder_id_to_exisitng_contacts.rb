# frozen_string_literal: true

class DataMigrationLoadBuilderIdToExisitngContacts < ActiveRecord::Migration[5.1]
  def change
    Contact.find_each do |contact|
      builder_id = contact&.division&.region&.builder_id
      contact.update_attribute(:builder_id, builder_id) if builder_id
    end
  end
end
