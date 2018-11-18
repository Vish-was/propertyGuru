class CreateBuildersUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :builders_users do |t|
      t.belongs_to  :user, index: true
      t.belongs_to  :builder, index: true
    end
  end
end
