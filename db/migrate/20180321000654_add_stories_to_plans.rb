class AddStoriesToPlans < ActiveRecord::Migration[5.1]
  def change
    add_column :plans, :stories, :decimal, null: false
  end
end
