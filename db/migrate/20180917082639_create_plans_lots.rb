class CreatePlansLots < ActiveRecord::Migration[5.1]
  def change
    create_table :plans_lots do |t|
      t.belongs_to  :plan, index: true
      t.belongs_to  :lot, index: true
    end
  end
end
