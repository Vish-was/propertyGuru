class AddColumnsToCommunities < ActiveRecord::Migration[5.1]
  def change
    add_column :communities, :yearly_hoa_fees, :integer, null: true
    add_column :communities, :property_tax_rate, :decimal, null: true
  end
end
