require 'rails_helper'
require 'rake'

RSpec.describe "data_load", type: :rake do

  let(:rake) { Rake::Application.new }
  let!(:builder) { create(:builder) }
  let(:builder_id) { builder.id }

  let!(:region) { create(:region, builder_id: builder_id) }
  let(:region_id) { region.id }
  let!(:collection) { create(:collection, region_id: region.id) }
  let!(:plan) { create(:plan, collection_id: collection.id) }
  let!(:plan_option_set) { create(:plan_option_set, plan_id: plan.id) }
  let!(:plan_option) { create(:plan_option, plan_option_set_id: plan_option_set.id) }
  let!(:elevation) { create(:elevation, plan_id: plan.id) }
  let!(:vr_scene) { create(:vr_scene, plan_id: plan.id) }
  let!(:plan_image) { create(:plan_image, plan_id: plan.id) }
  let!(:vr_hotspot) { create(:vr_hotspot, vr_scene_id: vr_scene.id) }
  let(:verbose) { false }

  describe 'Clear all the existing plans for a given collection' do
    let(:plans_destroy) { self.class.top_level_description }
    let(:task_path) { "lib/tasks/#{plans_destroy.split(":").first}" }
    subject         { rake[plans_destroy] }
    context "when collection exist" do
      before do
          Rake.application = rake
          Rake.application.rake_require(task_path, [Rails.root.to_s])
          Rake::Task.define_task(:environment)
          Rake.application.invoke_task("data_load:plans_destroy[#{collection.id},#{verbose}]")
      end

      it "should remove all plans of this collection" do
        expect(collection.reload.plans.length).to eq(0)
      end
    end
    context "when collection does not exist" do
      it 'returns a not found message' do
        puts "arguments required"
      end
    end
  end



  describe 'Load new elevations' do
    let(:elevations_load) { self.class.top_level_description }
    let(:task_path) { "lib/tasks/#{elevations_load.split(":").first}" }
    subject         { rake[elevations_load] }

    context "when builder exist" do

      before do
        Rake.application = rake
        Rake.application.rake_require(task_path, [Rails.root.to_s])
        Rake::Task.define_task(:environment)
        load File.join(Rails.root.to_s, 'lib/tasks/data_load.rake')
        header = "plan name,elevation name,description,price,image"
        data_new = "#{plan.name},M,M style elevation,0,#{Rails.root.to_s}/spec/lib/tasks/missing_images/elevations.png\n#{plan.name},O,O style elevation,25000,#{Rails.root.to_s}/spec/lib/tasks/missing_images/elevations.png\n#{plan.name},P,,15000,#{Rails.root.to_s}/spec/lib/tasks/missing_images/elevations.png\n#{plan.name},P,,15000,#{Rails.root.to_s}/spec/lib/tasks/missing_images/elevations.png\n#{plan.name},P,,15000,#{Rails.root.to_s}/spec/lib/tasks/missing_images/elevations.png"
        File.open("spec/lib/tasks/elevations.csv", 'w') { |file| file.write("#{header}\n#{data_new}\n#{data_new}")}
        Rake.application.invoke_task("data_load:elevations_load[#{builder_id},#{Rails.root.to_s+'/spec/lib/tasks/elevations.csv'},#{verbose}]")
        File.delete "spec/lib/tasks/elevations.csv"
      end

      it "should create all elevations of this plan" do
        expect(plan.elevations.length).to be > 0
      end
    end
    context "when builder does not exist" do
      it 'returns a not found message' do
        puts "arguments required"
      end
    end
  end

  describe 'Load new vr_scenes' do
    let(:vr_load) { self.class.top_level_description }
    let(:task_path) { "lib/tasks/#{vr_load.split(":").first}" }
    subject         { rake[vr_load] }
    context "when builder exist" do
      before do
        Rake.application = rake
        Rake.application.rake_require(task_path, [Rails.root.to_s])
        Rake::Task.define_task(:environment)
        load File.join(Rails.root.to_s, 'lib/tasks/data_load.rake')
        header = "Plan Name,VR Scene Name,Default VR Scene,VR Hotspot Name,VR Hotspot Type,Plan Option Set Name,Jump VR Scene Name,Position,Rotation,Toggle Method,Toggle Default,Show On Plan Option Set,Show On Plan Option Selected,Hide On Plan Option Set,Hide On Plan Option Selected"
        data_new = "#{plan.name},Front,TRUE,Garage,menu,Garage,,0 2 -7,0 0 0,,FALSE,,,,\n#{plan.name},Front,TRUE,Elevation,menu,Elevation,,-7 2 0,0 90 0,,FALSE,,,,\n#{plan.name},Front,TRUE,Entrance,jump,,Kitchen,-7 0 0,0 90 0,,FALSE,,,,\n#{plan.name},Front,TRUE,Wireframe,toggle,,,-7 2 5,0 -45 0,wireframe,FALSE,,,,\n#{plan.name},Kitchen,FALSE,Island,menu,Kitchen Island,,5 2 5,0 -135 0,,FALSE,,,,\n#{plan.name},Kitchen,FALSE,Kitchen Type,menu,Kitchen Type,,0 2 7,0 -180 0,,FALSE,,,,\n#{plan.name},Kitchen,FALSE,Fireplace,menu,Fireplace,,-10 2 0,0 90 0,,FALSE,,,,"
        File.open("spec/lib/tasks/vr_scenes.csv", 'w') { |file| file.write("#{header}\n#{data_new}\n#{data_new}")}
        Rake.application.invoke_task("data_load:vr_load[#{builder_id},#{Rails.root.to_s+'/spec/lib/tasks/vr_scenes.csv'},#{verbose}]")
        File.delete "spec/lib/tasks/vr_scenes.csv"
      end

      it "should create all vr_scenes of this plan" do
        expect(plan.vr_scenes.length).to be > 0
      end

      it "should create all vr_hotspots of this vr_scene" do
        expect(vr_scene.vr_hotspots.length).to be > 0
      end
    end
    context "when builder does not exist" do
      it 'returns a not found message' do
        puts "arguments required"
      end
    end
  end

  describe 'Load new plan_options' do

    let(:plan_options_load) { self.class.top_level_description }
    let(:task_path) { "lib/tasks/#{plan_options_load.split(":").first}" }
    subject         { rake[plan_options_load] }
    context "when builder exist" do
      before do
        Rake.application = rake
        Rake.application.rake_require(task_path, [Rails.root.to_s])
        Rake::Task.define_task(:environment)
        load File.join(Rails.root.to_s, 'lib/tasks/data_load.rake')
        header = "plan name,story,option set name,position 2d x,position 2d y,default option,option name,price,category,2d file,thumb file,vr link"
        data_new = "#{plan.name},1,Patio,0.1083,0.1674,TRUE,No Patio,0,patio,#{Rails.root.to_s}/spec/lib/tasks/missing_images/plan_options.png,#{Rails.root.to_s}/spec/lib/tasks/missing_images/plan_options.png,\n#{plan.name},1,Patio,0.1083,0.1674,FALSE,Extended Covered Patio,4500,patio,#{Rails.root.to_s}/spec/lib/tasks/missing_images/plan_options.png,,\n#{plan.name},1,,,,TRUE,Fireplace at Family Room,,,,,\n#{plan.name},1,,,,,Covered Patio,,patio,#{Rails.root.to_s}/spec/lib/tasks/missing_images/plan_options.png,#{Rails.root.to_s}/spec/lib/tasks/missing_images/plan_options.png,\n#{plan.name},1,,,,,2.5-Car Garage,,,,,"
        File.open("spec/lib/tasks/plan_options.csv", 'w') { |file| file.write("#{header}\n#{data_new}\n#{data_new}")}
        Rake.application.invoke_task("data_load:plan_options_load[#{builder.id},#{Rails.root.to_s+'/spec/lib/tasks/plan_options.csv'},#{verbose}]")
        File.delete "spec/lib/tasks/plan_options.csv"
      end

      it "should create all plan_options" do
        expect(plan_option_set.plan_options.length).to be > 0
      end
    end
    context "when builder does not exist" do
      it 'returns a not found message' do
        puts "arguments required"
      end
    end
  end
  describe 'Load plan_base_images_load' do
    let(:plan_base_images_load) { self.class.top_level_description }
    let(:task_path) { "lib/tasks/#{plan_base_images_load.split(":").first}" }
    subject         { rake[plan_base_images_load] }
    context "when builder exist" do
      before do
        Rake.application = rake
        Rake.application.rake_require(task_path, [Rails.root.to_s])
        Rake::Task.define_task(:environment)
        load File.join(Rails.root.to_s, 'lib/tasks/data_load.rake')
        header = "plan name,story,2d file"
        data_new = "#{plan.name},1,#{Rails.root.to_s}/spec/lib/tasks/missing_images/plan_images.png\n#{plan.name},2,#{Rails.root.to_s}/spec/lib/tasks/missing_images/plan_images.png"
        File.open("spec/lib/tasks/plan_images.csv", 'w') { |file| file.write("#{header}\n#{data_new}\n#{data_new}")}
        Rake.application.invoke_task("data_load:vr_load[#{builder_id},#{Rails.root.to_s+'/spec/lib/tasks/plan_images.csv'},#{verbose}]")
        File.delete "spec/lib/tasks/plan_images.csv"
      end
      it "should create all plan_images of this plan" do
        expect(plan.plan_images.length).to be > 0
      end
    end
    context "when builder does not exist" do
      it 'returns a not found message' do
        puts "arguments required"
      end
    end
  end  
end