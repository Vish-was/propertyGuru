namespace :data_load do

  desc "Clear all the existing plans for a given collection"
  task :plans_destroy, [:collection_id, :verbose] => :environment do |t, args|
    args.with_defaults(verbose: true)
    verbose = ActiveModel::Type::Boolean.new.cast(args[:verbose])
    puts "Collection ID: #{args[:collection_id]}" if verbose

    if args.collection_id.blank?
      puts "arguments required" if verbose
      exit
    end

    collection = Collection.find(args.collection_id)
    exit unless collection.present?
    puts "Collection #{collection.name} found" if verbose

    collection.plans.destroy_all
  end



  desc "Load new plans"
  task :plans_load, [:collection_id, :plan_file, :verbose] => :environment do |t, args|
    args.with_defaults(verbose: true)
    verbose = ActiveModel::Type::Boolean.new.cast(args[:verbose])
    puts "Collection ID: #{args[:collection_id]}" if verbose
    puts "Plan file: #{args[:plan_file]}\n\n" if verbose

    if args.plan_file.blank? or args.collection_id.blank?
      puts "arguments required" if verbose
      exit
    end

    collection = Collection.find(args.collection_id)
    exit unless collection.present?
    puts "Collection #{collection.name} found" if verbose

    CSV.foreach(args[:plan_file], :headers => true) do |row|
      plan = Plan.where('collection_id = ? and name = ?', args.collection_id, row['plan name']).first
      if plan.present?
        puts "Plan #{row['plan name']} already exists, skipping..." if verbose
        next
      end

      if row.present?
      plan = Plan.create(
        name: row['plan name'],
        min_price: row['base price'], 
        min_sqft: row['base sqft'],  
        min_bedrooms: row['base bed'], 
        min_bathrooms: row['base bath'], 
        min_garage: row['base garage'], 
        max_price: row['max price'],
        max_sqft: row['max sqft'],
        max_bedrooms: row['max bed'], 
        max_bathrooms: row['max bath'], 
        max_garage: row['max garage'], 
        min_stories: row['base stories'], 
        max_stories: row['max stories'], 
        image: File.open(row['image']),
        collection: collection)
      puts "New #{plan.name} Plan created!" if verbose
        style = PlanStyle.find_by_name(row['style'])
        if style.nil?
          first_style = PlanStyle.first
          style = PlanStyle.create(
            name: row['style'],
            image_file_name: first_style.image_file_name,
            image_content_type: first_style.image_content_type,
            image_file_size: first_style.image_file_size,
            image_updated_at: DateTime.now)
          puts "New #{style.name} PlanStyle created!" if verbose
        end

        plan.plan_styles << style
      end
    end
  end


  desc "Load new plan_options"
  task :plan_options_load, [:builder_id, :plan_option_file, :verbose] => :environment do |t, args|
    args.with_defaults(verbose: true)
    verbose = ActiveModel::Type::Boolean.new.cast(args[:verbose])
    puts "Builder ID: #{args[:builder_id]}" if verbose
    puts "PlanOption file: #{args[:plan_option_file]}\n\n" if verbose

    if args.plan_option_file.blank? or args.builder_id.blank?
      puts "arguments required" if verbose
      exit
    end

    builder = Builder.find(args.builder_id)
    exit unless builder.present?
    puts "Builder #{builder.name} found" if verbose

    CSV.foreach(args[:plan_option_file], :headers => true) do |row|
      plan = Plan.joins(:collection=>[:region=>:builder]).where('builders.id = ? and plans.name = ?', args.builder_id, row['plan name']).first
      if plan.blank?
        puts "Could not find plan #{row['plan name']} for builder #{builder.name}. Skipping..." if verbose
        next
      end
    
      unless row['option set name'].blank?
        plan_option_set = PlanOptionSet.where('plan_id = ? and name = ?', plan.id, row['option set name']).first

        if plan_option_set.blank?
          plan_option_set = PlanOptionSet.create(
            name: row['option set name'],
            plan: plan,
            story: row['story'], 
            position_2d_x: row['position 2d x'],
            position_2d_y: row['position 2d y'])
          if plan_option_set.valid?
            puts "New #{plan_option_set.name} PlanOptionSet created!" if verbose
          else
            puts "#{plan_option_set.name} PlanOptionSet failed: #{plan_option_set.errors.messages}" if verbose
          end
        end
      else
        puts "Could not find plan option set name. Skipping..." if verbose
        next
      end
      
      if row['thumb file'].nil? || row['2d file'].nil?
        if verbose
          puts "Could not find thumbnail image. Skipping..." if row['thumb file'].blank? 
          puts "Could not find plan image. Skipping..." if row['2d file'].blank?
        end
        next
      else
        plan_option = PlanOption.new(
          name: row['option name'],
          default_price: row['price'], 
          category: row['category'],   
          vr_parameter: row['vr link'],
          plan_option_set: plan_option_set,
          thumbnail_image: File.open(row['thumb file']),
          plan_image: File.open(row['2d file'])
        )
        if plan_option.save
          puts "New #{plan_option.name} PlanOption created!" if verbose

          if ActiveModel::Type::Boolean.new.cast(row['default option'].downcase)
            plan_option_set.default_plan_option_id = plan_option.id
            plan_option_set.save
            puts "#{plan_option.name} set as default PlanOption for #{plan_option_set.name} PlanOptionSet" if verbose
          end
        else
          puts "#{plan_option.errors.full_messages}" if verbose
        end
      end
    end
  end


  desc "Load new elevations"
  task :elevations_load, [:builder_id, :elevation_file, :verbose] => :environment do |t, args|
    args.with_defaults(verbose: true)
    verbose = ActiveModel::Type::Boolean.new.cast(args[:verbose])
    puts "Builder ID: #{args[:builder_id]}" if verbose
    puts "Elevation file: #{args[:elevation_file]}\n\n" if verbose

    if args.elevation_file.blank? or args.builder_id.blank?
      puts "arguments required" if verbose
      exit
    end

    builder = Builder.find(args.builder_id)
    exit unless builder.present?
    puts "Builder #{builder.name} found" if verbose

    CSV.foreach(args[:elevation_file], :headers => true) do |row|
      plan =  Plan.joins(:collection=>[:region=>:builder]).where('builders.id = ? and plans.name = ?', args.builder_id, row['plan name']).first
      if plan.blank?
        puts "Could not find plan #{row['Plan Name']} for builder #{builder.name}. Skipping..." if verbose
        next
      end

      elevation_data = {
        name: row['elevation name'],
        price: row['price'], 
        description: row['description']
      }
      elevation_data[:image] =  File.open(row['image']) unless row['image'].blank?
      elevation_data[:plan] =  plan unless plan.blank?

      elevation = Elevation.create(elevation_data)
      puts "New #{elevation.name} Elevation for Plan #{plan.name} created!" if verbose
    end
  end

  desc "Load new vr_scenes"
  task :vr_load, [:builder_id, :vr_scene_file, :verbose] => :environment do |t, args|
    args.with_defaults(verbose: true)
    verbose = ActiveModel::Type::Boolean.new.cast(args[:verbose])
    puts "Builder ID: #{args[:builder_id]}" if verbose
    puts "VrScene file: #{args[:vr_scene_file]}\n\n" if verbose

    if args.vr_scene_file.blank? or args.builder_id.blank?
      puts "arguments required" if verbose
      exit
    end

    builder = Builder.find(args.builder_id)
    exit unless builder.present?
    puts "Builder #{builder.name} found" if verbose
    
    CSV.foreach(args[:vr_scene_file], :headers => true) do |row|
      plan =  Plan.joins(:collection=>[:region=>:builder]).where('builders.id = ? and plans.name = ?', args.builder_id, row['Plan Name']).first
      if plan.blank?
        puts "Could not find plan #{row['plan name']} for builder #{builder.name}. Skipping..." if verbose
        next
      end

      unless row['VR Scene Name'].nil?
        vr_scene = VrScene.find_by_name(row['VR Scene Name'])
        if vr_scene.nil?

          vr_scene = VrScene.create(
            name: row['VR Scene Name'],
            plan: plan
          )
          puts "New #{vr_scene.name} VrScene for Plan #{plan.name} created!" if verbose
          plan.default_vr_scene_id = vr_scene.id if row['Default VR Scene'] == "TRUE"
          plan.save
        end
      else
        puts "Could not find vr scene name. Skipping..." if verbose
        next
      end

      unless row['VR Hotspot Name'].nil?
        vr_hotspot = VrHotspot.find_by_name(row['VR Hotspot Name'])
        jump_vr_scene = VrScene.find_by_name(['Jump VR Scene Name'])
        if row['Show On Plan Option Selected'].present? 
          show_on_plan_option = PlanOption.find_by_name(row['Show On Plan Option Selected'])
          show_on_plan_option_id = show_on_plan_option.id
          plan_option_set = PlanOptionSet.find_by_name(row['Show On Plan Option Set'])
        elsif row['Hide On Plan Option Selected'].present? 
          hide_on_plan_option = PlanOption.find_by_name(row['Hide On Plan Option Selected'])
          hide_on_plan_option_id = hide_on_plan_option.id
          plan_option_set = PlanOptionSet.find_by_name(row['Hide On Plan Option Set'])
        else 
          plan_option_set = PlanOptionSet.find_by_name(row['Plan Option Set Name'])
          show_on_plan_option_id = nil
          hide_on_plan_option_id = nil  
        end
        unless jump_vr_scene.nil?
          jump_vr_scene_id = jump_vr_scene.id
        else
          jump_vr_scene_id = nil;
        end
        if vr_hotspot.nil?

          vr_hotspot = VrHotspot.create(
            name: row['VR Hotspot Name'],
            vr_scene: vr_scene,
            plan_option_set: plan_option_set,
            jump_scene_id: jump_vr_scene_id,
            position: row['Position'],
            rotation: row['Rotation'],
            toggle_method: row['Toggle Method'],
            type: row['VR Hotspot Type'],
            toggle_default: row['Toggle Default'],
            show_on_plan_option_id: show_on_plan_option_id,
            hide_on_plan_option_id: hide_on_plan_option_id
          )
          puts "New #{vr_hotspot.name} VrHotspot for VrScene #{vr_scene.name} created!" if verbose
        end
      else
        puts "Could not find vr hotspot name. Skipping..." if verbose
        next
      end
    end
  end
  desc "Load plan_base_images_load"
  task :plan_base_images_load, [:builder_id, :plan_base_images_file, :verbose] => :environment do |t, args|
    args.with_defaults(verbose: true)
    verbose = ActiveModel::Type::Boolean.new.cast(args[:verbose])
    puts "Builder ID: #{args[:builder_id]}" if verbose
    puts "PlanBaseImage file: #{args[:plan_base_images_file]}\n\n" if verbose
    if args.plan_base_images_file.blank? or args.builder_id.blank?
      puts "arguments required" if verbose
      exit
    end
    builder = Builder.find(args.builder_id)
    exit unless builder.present?
    puts "Builder #{builder.name} found" if verbose
    CSV.foreach(args[:plan_base_images_file], :headers => true) do |row|
      plan = Plan.joins(:collection=>[:region=>:builder]).where('builders.id = ? and plans.name = ?', args.builder_id, row['plan name']).first
      if plan.blank?
        puts "Could not find plan #{row['plan name']} for builder #{builder.name}. Skipping..." if verbose
        next
      end
      unless row['2d file'].blank? || row['story'].blank?
        plan_image = PlanImage.where('plan_id = ? and story = ?', plan.id, row['story']).first
        if plan_image.present?
          plan_image.update(
            plan: plan,
            story: row['story'], 
            base_image: File.open(row['2d file']))
          puts "Plan image updated" if verbose   
        else
          plan_image = PlanImage.new(
            plan: plan,
            story: row['story'],
            base_image: File.open(row['2d file']))
          if plan_image.save
            puts "New PlanImage created!" if verbose
          else
            puts "PlanImage failed: #{plan_image.errors.messages}" if verbose
          end
        end
      else
        puts "Could not find plan image. Skipping..." if verbose
        next
      end
    end
  end  
end

