class ChangeStoryColumn < ActiveRecord::Migration[5.1]
  def change
  	rename_column :plans, :stories, :min_stories
  	add_column :plans, :max_stories, :decimal, null: true
  end
end
