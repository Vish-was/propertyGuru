class AddCommunityAssociationChanges < ActiveRecord::Migration[5.1]
  def change
  	remove_reference :lots, :division, foreign_key: true
  	add_reference :lots, :community, foreign_key: true
  end
end
