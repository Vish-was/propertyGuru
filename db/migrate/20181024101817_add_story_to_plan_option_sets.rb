class AddStoryToPlanOptionSets < ActiveRecord::Migration[5.1]
  def up
  	add_column :plan_option_sets, :story, :decimal, default: "1.0", null: false
  	execute "UPDATE plan_option_sets pos SET story = (SELECT po.story FROM plan_options po WHERE pos.default_plan_option_id = po.id);"	
  	remove_column :plan_options, :story
  end

  def down
  	add_column :plan_options, :story, :decimal, default: "1.0", null: false
  	execute "UPDATE plan_options po SET story = (SELECT pos.story FROM plan_option_sets pos WHERE po.id = pos.default_plan_option_id);"
  	remove_column :plan_option_sets, :story
  end	
end
