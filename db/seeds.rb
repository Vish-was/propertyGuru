# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
require 'database_cleaner'
require 'faker'
require 'factory_bot'
include FactoryBot::Syntax::Methods
FactoryBot.find_definitions

DatabaseCleaner.clean_with :truncation, { except: ['spatial_ref_sys'] }

gehan=Builder.create name: 'Gehan Homes'
texas=Region.create name: 'Texas', builder: gehan
centex=Division.create name: 'Central Texas', region: texas

premier=Collection.create(
  name: 'Premier',
  information: 'Offered in a wide range of square footages from 1,850 to over 3,200, our Premier series of plans highlight upgraded standard features. These new construction homes in Texas are 40’ wide and thoughtfully designed. Soaker tubs, formal dining rooms and large secondary bedrooms are just some of the many features offered.',
  region: texas)

ranch=
PlanStyle.create(
  name: 'Ranch',
# image: File.open('/tmp/ranch.jpg'),
  image_file_name: "ranch.jpg",
  image_content_type: "image/jpeg",
  image_file_size: 8340,
  image_updated_at: DateTime.now,
  )

PlanStyle.create(
  name: 'Contemporary',
  # image: File.open('/tmp/contemporary.jpg'),
  image_file_name: "contemporary.jpg",
  image_content_type: "image/jpeg",
  image_file_size: 8340,
  image_updated_at: DateTime.now)

PlanStyle.create(
  name: 'Italian',
  # image: File.open('/tmp/italian.jpg'),
  image_file_name: "italian.jpg",
  image_content_type: "image/jpeg",
  image_file_size: 8340,
  image_updated_at: DateTime.now)

PlanStyle.create(
  name: 'Western',
  # image: File.open('/tmp/western.jpg'),
  image_file_name: "western.jpg",
  image_content_type: "image/jpeg",
  image_file_size: 8340,
  image_updated_at: DateTime.now)

traditional=
PlanStyle.create(
  name: 'Traditional',
  # image: File.open('/tmp/traditional.jpg'),
  image_file_name: "traditional.jpg",
  image_content_type: "image/jpeg",
  image_file_size: 8340,
  image_updated_at: DateTime.now)

PlanStyle.create(
  name: 'Mission',
  # image: File.open('/tmp/mission.jpg'),
  image_file_name: "mission.jpg",
  image_content_type: "image/jpeg",
  image_file_size: 8340,
  image_updated_at: DateTime.now)

craftsman=
PlanStyle.create(
  name: 'Craftsman',
  # image: File.open('/tmp/craftsman.jpg'),
  image_file_name: "craftsman.jpg",
  image_content_type: "image/jpeg",
  image_file_size: 8340,
  image_updated_at: DateTime.now)

PlanStyle.create(
  name: 'Colonial',
  # image: File.open('/tmp/colonial.jpg'),
  image_file_name: "colonial.jpg",
  image_content_type: "image/jpeg",
  image_file_size: 8340,
  image_updated_at: DateTime.now)


############################
######### Rosewood #########
############################

rosewood=Plan.create(
  name: 'Rosewood',
  information: '4 Beds | 2.5 Baths | 2 Garage | 2 Stories | 3,050+ Square Feet',
  min_price: 339000,
  min_sqft: 3050,
  min_bedrooms: 4,
  min_bathrooms: 2.5,
  min_garage: 2,
  min_stories: 2,
  image_file_name: "rosewood.jpg",
  image_content_type: "image/jpeg",
  image_file_size: 169971,
  image_updated_at: DateTime.now,
  # image: File.open('/tmp/rosewood.jpg'),
  collection_id: 1)

PlanImage.create(
  story: 1,
  base_image_file_name: "base.png",
  base_image_content_type: "image/png",
  base_image_file_size: 2886304,
  base_image_updated_at: DateTime.now,
  # base_image: File.open('/tmp/floor1/base.png'),
  plan: rosewood)

PlanImage.create(
  story: 2,
  base_image_file_name: "base.png",
  base_image_content_type: "image/png",
  base_image_file_size: 165469,
  base_image_updated_at: DateTime.now,
  # base_image: File.open('/tmp/floor2/base.png'),
  plan: rosewood)

rosewoodFireplace=
PlanOption.create(
  name: 'Fireplace at Family Room',
  information: 'This is more descriptive text about this plan option',
  default_price: 500,
  category: 'living',
  thumbnail_image_file_name: "fireplace_family_thumb.png",
  thumbnail_image_content_type: "image/png",
  thumbnail_image_file_size: 1742,
  thumbnail_image_updated_at: DateTime.now,
  plan_image_file_name: "fireplace_family.png",
  plan_image_content_type: "image/png",
  plan_image_file_size: 61521,
  plan_image_updated_at: DateTime.now,
  # thumbnail_image: File.open('/tmp/floor1/fireplace_family_thumb.png'),
  # plan_image: File.open('/tmp/floor1/fireplace_family.png'),
  )

rosewoodGarage25=
PlanOption.create(
  name: '2.5-Car Garage',
  information: 'This is more descriptive text about this plan option',
  default_price: 1200,
  category: 'garage',
  thumbnail_image_file_name: "garage_2_5_thumb.png",
  thumbnail_image_content_type: "image/png",
  thumbnail_image_file_size: 24495, 
  thumbnail_image_updated_at: DateTime.now,
  plan_image_file_name: "garage_2_5.png",
  plan_image_content_type: "image/png",
  plan_image_file_size: 210947,
  plan_image_updated_at: DateTime.now,
  # thumbnail_image: File.open('/tmp/floor1/garage_2_5_thumb.png'),
  # plan_image: File.open('/tmp/floor1/garage_2_5.png'),
  )

rosewoodGarage3=
PlanOption.create(
  name: '3-Car Garage',
  information: 'This is more descriptive text about this plan option',
  default_price: 5000,
  category: 'garage',
  thumbnail_image_file_name: "garage_3_thumb.png",
  thumbnail_image_content_type: "image/png",
  thumbnail_image_file_size: 34431,
  thumbnail_image_updated_at: DateTime.now,
  plan_image_file_name: "garage_3.png",
  plan_image_content_type: "image/png",
  plan_image_file_size: 241161,
  plan_image_updated_at: DateTime.now,
  # thumbnail_image: File.open('/tmp/floor1/garage_3_thumb.png'),
  # plan_image: File.open('/tmp/floor1/garage_3.png'),
  )

rosewoodBayWindow=
PlanOption.create(
  name: 'Bay at Master Bedroom',
  information: 'This is more descriptive text about this plan option',
  default_price: 6000,
  category: 'bedroom',
  thumbnail_image_file_name: "bay_window_thumb.png",
  thumbnail_image_content_type: "image/png",
  thumbnail_image_file_size: 16114,
  thumbnail_image_updated_at: DateTime.now,
  plan_image_file_name: "bay_window.png",
  plan_image_content_type: "image/png",
  plan_image_file_size: 164400,
  plan_image_updated_at: DateTime.now,
  # thumbnail_image: File.open('/tmp/floor1/bay_window_thumb.png'),
  # plan_image: File.open('/tmp/floor1/bay_window.png'),
  )

rosewoodIsland1=
PlanOption.create(
  name: 'Island #1',
  information: 'This is more descriptive text about this plan option',
  default_price: 1500,
  category: 'kitchen',
  thumbnail_image_file_name: "island_1_thumb.png",
  thumbnail_image_content_type: "image/png",
  thumbnail_image_file_size: 16890,
  thumbnail_image_updated_at: DateTime.now,
  plan_image_file_name: "island_1.png",
  plan_image_content_type: "image/png",
  plan_image_file_size: 181463,
  plan_image_updated_at: DateTime.now,
  # thumbnail_image: File.open('/tmp/floor1/island_1_thumb.png'),
  # plan_image: File.open('/tmp/floor1/island_1.png'),
  )

rosewoodIsland2=
PlanOption.create(
  name: 'Island #2',
  information: 'This is more descriptive text about this plan option',
  default_price: 1000,
  category: 'kitchen',
  thumbnail_image_file_name: "island_2_thumb.png",
  thumbnail_image_content_type: "image/png",
  thumbnail_image_file_size: 16044,
  thumbnail_image_updated_at: DateTime.now,
  plan_image_file_name: "island_2.png",
  plan_image_content_type: "image/png",
  plan_image_file_size: 167813,
  plan_image_updated_at: DateTime.now,
  # thumbnail_image: File.open('/tmp/floor1/island_2_thumb.png'),
  # plan_image: File.open('/tmp/floor1/island_2.png'),
  )

rosewoodStudy=
PlanOption.create(
  name: 'Study',
  information: 'This is more descriptive text about this plan option',
  default_price: 830,
  category: 'bedroom',
  thumbnail_image_file_name: "study_thumb.png",
  thumbnail_image_content_type: "image/png",
  thumbnail_image_file_size: 31449,
  thumbnail_image_updated_at: DateTime.now,
  plan_image_file_name: "study.png",
  plan_image_content_type: "image/png",
  plan_image_file_size: 323556,
  plan_image_updated_at: DateTime.now,
  # thumbnail_image: File.open('/tmp/floor1/study_thumb.png'),
  # plan_image: File.open('/tmp/floor1/study.png'),
  )

rosewoodBedroom5=
PlanOption.create(
  name: 'Bedroom #5 with Bath #3',
  information: 'This is more descriptive text about this plan option',
  default_price: 25000,
  category: 'bedroom',
  thumbnail_image_file_name: "bedroom_5_thumb.png",
  thumbnail_image_content_type: "image/png",
  thumbnail_image_file_size: 48414,
  thumbnail_image_updated_at: DateTime.now,
  plan_image_file_name: "bedroom_5.png",
  plan_image_content_type: "image/png",
  plan_image_file_size: 444330,
  plan_image_updated_at: DateTime.now,
  # thumbnail_image: File.open('/tmp/floor1/bedroom_5_thumb.png'),
  # plan_image: File.open('/tmp/floor1/bedroom_5.png'),
  )

rosewoodCoveredPatio=
PlanOption.create(
  name: 'Covered Patio',
  information: 'This is more descriptive text about this plan option',
  default_price: 4000,
  category: 'patio',
  thumbnail_image_file_name: "covered_patio_thumb.png",
  thumbnail_image_content_type: "image/png",
  thumbnail_image_file_size: 15679,
  thumbnail_image_updated_at: DateTime.now,
  plan_image_file_name: "covered_patio.png",
  plan_image_content_type: "image/png",
  plan_image_file_size: 166314,
  plan_image_updated_at: DateTime.now,
  # thumbnail_image: File.open('/tmp/floor1/covered_patio_thumb.png'),
  # plan_image: File.open('/tmp/floor1/covered_patio.png'),
  )

rosewoodExtendedCoveredPatio=
PlanOption.create(
  name: 'Extended Covered Patio',
  information: 'This is more descriptive text about this plan option',
  default_price: 4000,
  category: 'patio',
  thumbnail_image_file_name: "extended_patio_thumb.png",
  thumbnail_image_content_type: "image/png",
  thumbnail_image_file_size: 49695,
  thumbnail_image_updated_at: DateTime.now,
  plan_image_file_name: "extended_patio.png",
  plan_image_content_type: "image/png",
  plan_image_file_size: 410637,
  plan_image_updated_at: DateTime.now,
  # thumbnail_image: File.open('/tmp/floor1/extended_patio_thumb.png'),
  # plan_image: File.open('/tmp/floor1/extended_patio.png'),
  )

rosewoodMediaRoom=
PlanOption.create(
  name: 'Media Room',
  information: 'This is more descriptive text about this plan option',
  default_price: 17000,
  category: 'bedroom',
  thumbnail_image_file_name: "media_room_thumb.png",
  thumbnail_image_content_type: "image/png",
  thumbnail_image_file_size: 55611,
  thumbnail_image_updated_at: DateTime.now,
  plan_image_file_name: "media_room.png",
  plan_image_content_type: "image/png",
  plan_image_file_size: 516371,
  plan_image_updated_at: DateTime.now,
  # thumbnail_image: File.open('/tmp/floor2/media_room_thumb.png'),
  # plan_image: File.open('/tmp/floor2/media_room.png'),
  )

ExcludedPlanOption.create(
  plan_option: rosewoodGarage25,
  excluded_plan_option_id: rosewoodGarage3.id)

ExcludedPlanOption.create(
  plan_option: rosewoodGarage3,
  excluded_plan_option_id: rosewoodGarage25.id)

ExcludedPlanOption.create(
  plan_option: rosewoodIsland1,
  excluded_plan_option_id: rosewoodIsland2.id)

ExcludedPlanOption.create(
  plan_option: rosewoodIsland2,
  excluded_plan_option_id: rosewoodIsland1.id)

ExcludedPlanOption.create(
  plan_option: rosewoodStudy,
  excluded_plan_option_id: rosewoodBedroom5.id)

ExcludedPlanOption.create(
  plan_option: rosewoodBedroom5,
  excluded_plan_option_id: rosewoodStudy.id)

ExcludedPlanOption.create(
  plan_option: rosewoodCoveredPatio,
  excluded_plan_option_id: rosewoodExtendedCoveredPatio.id)

ExcludedPlanOption.create(
  plan_option: rosewoodExtendedCoveredPatio,
  excluded_plan_option_id: rosewoodCoveredPatio.id)


Elevation.create(
  name: 'Rosewood M',
  description: "Here's a brief rundown of the style of this elevation",
  price: 0,
  image_file_name: "gehan-homes-premier-rosewood-m-elevation.jpg",
  image_content_type: "image/jpeg",
  image_file_size: 11782,
  image_updated_at: DateTime.now,
  # image: URI.parse('http://www.gehanhomes.com/media/44026/gehan-homes-premier-rosewood-m-elevation.jpg'), 
  plan: rosewood)

Elevation.create(
  name: 'Rosewood O',
  description: "Here's a brief rundown of the style of this elevation",
  price: 22000,
  image_file_name: "gehan-homes-premier-rosewood-o-elevation.jpg",
  image_content_type: "image/jpeg",
  image_file_size: 12117,
  image_updated_at: DateTime.now,
  # image: URI.parse('http://www.gehanhomes.com/media/44027/gehan-homes-premier-rosewood-o-elevation.jpg'), 
  plan: rosewood)

Elevation.create(
  name: 'Rosewood P',
  description: "Here's a brief rundown of the style of this elevation",
  price: 8000,
  image_file_name: "gehan-homes-premier-rosewood-p-elevation.jpg",
  image_content_type: "image/jpeg",
  image_file_size: 12579,
  image_updated_at: DateTime.now,
  # image: URI.parse('http://www.gehanhomes.com/media/44028/gehan-homes-premier-rosewood-p-elevation.jpg'), 
  plan: rosewood)

############################
########## Laurel ##########
############################

laurel=Plan.create(
  name: 'Laurel',
  information: '3 Beds | 2 Baths | 2 Garage | 1 Story | 2,020+ Square Feet',
  min_price: 232500,
  min_sqft: 2020,
  min_bedrooms: 3,
  min_bathrooms: 2,
  min_garage: 2,
  min_stories: 1,
  image_file_name: "laurel.jpg",
  image_content_type: "image/jpeg",
  image_file_size: 193796,
  image_updated_at: DateTime.now,
  # image: File.open('/tmp/laurel.jpg'),
  collection: premier)

PlanImage.create(
  story: 1,
  base_image_file_name: "laurel-first-floor-plan.jpg",
  base_image_content_type: "image/jpeg",
  base_image_file_size: 167339,
  base_image_updated_at: DateTime.now,
  # base_image: URI.parse('http://www.gehanhomes.com/media/50129/laurel-first-floor-plan.jpg'),
  plan: laurel)

laurelCoveredPatio=
PlanOption.create(
  name: 'Covered Patio',
  information: 'This is more descriptive text about this plan option',
  default_price: 15000,
  category: 'yard',
  thumbnail_image_file_name: "laurel-first-floor-plan.jpg",
  thumbnail_image_content_type: "image/jpeg",
  thumbnail_image_file_size: 167339,
  thumbnail_image_updated_at: DateTime.now,
  plan_image_file_name: "laurel-first-floor-plan.jpg",
  plan_image_content_type: "image/jpeg",
  plan_image_file_size: 167339,
  plan_image_updated_at: DateTime.now,
  # thumbnail_image: File.open('/tmp/floor1/bedroom_5_thumb.png'),
  # plan_image: File.open('/tmp/floor1/bedroom_5.png'),
  )

laurel3FootExt=
PlanOption.create(
  name: "3' Extension",
  information: 'This is more descriptive text about this plan option',
  default_price: 18400,
  category: 'footprint',
  thumbnail_image_file_name: "laurel-first-floor-plan.jpg",
  thumbnail_image_content_type: "image/jpeg",
  thumbnail_image_file_size: 167339,
  thumbnail_image_updated_at: DateTime.now,
  plan_image_file_name: "laurel-first-floor-plan.jpg",
  plan_image_content_type: "image/jpeg",
  plan_image_file_size: 167339,
  plan_image_updated_at: DateTime.now,
  # thumbnail_image: File.open('/tmp/floor1/bedroom_5_thumb.png'),
  # plan_image: File.open('/tmp/floor1/bedroom_5.png'),
  )

laurelExtendedCoveredPatio=
PlanOption.create(
  name: 'Extended Covered Patio',
  information: 'This is more descriptive text about this plan option',
  default_price: 15000,
  category: 'yard',
  thumbnail_image_file_name: "laurel-first-floor-plan.jpg",
  thumbnail_image_content_type: "image/jpeg",
  thumbnail_image_file_size: 167339,
  thumbnail_image_updated_at: DateTime.now,
  plan_image_file_name: "laurel-first-floor-plan.jpg",
  plan_image_content_type: "image/jpeg",
  plan_image_file_size: 167339,
  plan_image_updated_at: DateTime.now,
  # thumbnail_image: File.open('/tmp/floor1/bedroom_5_thumb.png'),
  # plan_image: File.open('/tmp/floor1/bedroom_5.png'),
  )

PlanOption.create(
  name: 'Study #2',
  information: 'This is more descriptive text about this plan option',
  default_price: 460,
  category: 'bedroom',
  thumbnail_image_file_name: "laurel-first-floor-plan.jpg",
  thumbnail_image_content_type: "image/jpeg",
  thumbnail_image_file_size: 167339,
  thumbnail_image_updated_at: DateTime.now,
  plan_image_file_name: "laurel-first-floor-plan.jpg",
  plan_image_content_type: "image/jpeg",
  plan_image_file_size: 167339,
  plan_image_updated_at: DateTime.now,
  # thumbnail_image: File.open('/tmp/floor1/bedroom_5_thumb.png'),
  # plan_image: File.open('/tmp/floor1/bedroom_5.png'),
  )

laurelBedroom4=
PlanOption.create(
  name: 'Bedroom 4',
  information: 'This is more descriptive text about this plan option',
  default_price: 25000,
  category: 'bedroom',
  thumbnail_image_file_name: "laurel-first-floor-plan.jpg",
  thumbnail_image_content_type: "image/jpeg",
  thumbnail_image_file_size: 167339,
  thumbnail_image_updated_at: DateTime.now,
  plan_image_file_name: "laurel-first-floor-plan.jpg",
  plan_image_content_type: "image/jpeg",
  plan_image_file_size: 167339,
  plan_image_updated_at: DateTime.now,
  # thumbnail_image: File.open('/tmp/floor1/bedroom_5_thumb.png'),
  # plan_image: File.open('/tmp/floor1/bedroom_5.png'),
  )

laurelBayMastBed=
PlanOption.create(
  name: 'Bay at Master Bedroom',
  information: 'This is more descriptive text about this plan option',
  default_price: 2000,
  category: 'bedroom',
  thumbnail_image_file_name: "laurel-first-floor-plan.jpg",
  thumbnail_image_content_type: "image/jpeg",
  thumbnail_image_file_size: 167339,
  thumbnail_image_updated_at: DateTime.now,
  plan_image_file_name: "laurel-first-floor-plan.jpg",
  plan_image_content_type: "image/jpeg",
  plan_image_file_size: 167339,
  plan_image_updated_at: DateTime.now,
  # thumbnail_image: File.open('/tmp/floor1/bedroom_5_thumb.png'),
  # plan_image: File.open('/tmp/floor1/bedroom_5.png'),
  )

laurelDesk=
PlanOption.create(
  name: 'Desk',
  information: 'This is more descriptive text about this plan option',
  default_price: 930,
  category: 'bedroom',
  thumbnail_image_file_name: "laurel-first-floor-plan.jpg",
  thumbnail_image_content_type: "image/jpeg",
  thumbnail_image_file_size: 167339,
  thumbnail_image_updated_at: DateTime.now,
  plan_image_file_name: "laurel-first-floor-plan.jpg",
  plan_image_content_type: "image/jpeg",
  plan_image_file_size: 167339,
  plan_image_updated_at: DateTime.now,
  # thumbnail_image: File.open('/tmp/floor1/bedroom_5_thumb.png'),
  # plan_image: File.open('/tmp/floor1/bedroom_5.png'),
  )

laurelFireplace=
PlanOption.create(
  name: 'Fireplace',
  information: 'This is more descriptive text about this plan option',
  default_price: 1100,
  category: 'living',
  thumbnail_image_file_name: "laurel-first-floor-plan.jpg",
  thumbnail_image_content_type: "image/jpeg",
  thumbnail_image_file_size: 167339,
  thumbnail_image_updated_at: DateTime.now,
  plan_image_file_name: "laurel-first-floor-plan.jpg",
  plan_image_content_type: "image/jpeg",
  plan_image_file_size: 167339,
  plan_image_updated_at: DateTime.now,
  # thumbnail_image: File.open('/tmp/floor1/bedroom_5_thumb.png'),
  # plan_image: File.open('/tmp/floor1/bedroom_5.png'),
  )

laurel25Garage=
PlanOption.create(
  name: '2 1/2 Car Garage',
  information: 'This is more descriptive text about this plan option',
  default_price: 3400,
  category: 'garage',
  thumbnail_image_file_name: "laurel-first-floor-plan.jpg",
  thumbnail_image_content_type: "image/jpeg",
  thumbnail_image_file_size: 167339,
  thumbnail_image_updated_at: DateTime.now,
  plan_image_file_name: "laurel-first-floor-plan.jpg",
  plan_image_content_type: "image/jpeg",
  plan_image_file_size: 167339,
  plan_image_updated_at: DateTime.now,
  # thumbnail_image: File.open('/tmp/floor1/bedroom_5_thumb.png'),
  # plan_image: File.open('/tmp/floor1/bedroom_5.png'),
  )

laurel3Garage=
PlanOption.create(
  name: '3 Car Garage',
  information: 'This is more descriptive text about this plan option',
  default_price: 5100,
  category: 'garage',
  thumbnail_image_file_name: "laurel-first-floor-plan.jpg",
  thumbnail_image_content_type: "image/jpeg",
  thumbnail_image_file_size: 167339,
  thumbnail_image_updated_at: DateTime.now,
  plan_image_file_name: "laurel-first-floor-plan.jpg",
  plan_image_content_type: "image/jpeg",
  plan_image_file_size: 167339,
  plan_image_updated_at: DateTime.now,
  # thumbnail_image: File.open('/tmp/floor1/bedroom_5_thumb.png'),
  # plan_image: File.open('/tmp/floor1/bedroom_5.png'),
  )

laurelGarage3Ext=
PlanOption.create(
  name: '3\' Garage Entension',
  information: 'This is more descriptive text about this plan option',
  default_price: 3170,
  category: 'garage',
  thumbnail_image_file_name: "laurel-first-floor-plan.jpg",
  thumbnail_image_content_type: "image/jpeg",
  thumbnail_image_file_size: 167339,
  thumbnail_image_updated_at: DateTime.now,
  plan_image_file_name: "laurel-first-floor-plan.jpg",
  plan_image_content_type: "image/jpeg",
  plan_image_file_size: 167339,
  plan_image_updated_at: DateTime.now,
  # thumbnail_image: File.open('/tmp/floor1/bedroom_5_thumb.png'),
  # plan_image: File.open('/tmp/floor1/bedroom_5.png'),
  )

laurelGrage6Ext=
PlanOption.create(
  name: '6\' Garage Entension',
  information: 'This is more descriptive text about this plan option',
  default_price: 5020,
  category: 'garage',
  thumbnail_image_file_name: "laurel-first-floor-plan.jpg",
  thumbnail_image_content_type: "image/jpeg",
  thumbnail_image_file_size: 167339,
  thumbnail_image_updated_at: DateTime.now,
  plan_image_file_name: "laurel-first-floor-plan.jpg",
  plan_image_content_type: "image/jpeg",
  plan_image_file_size: 167339,
  plan_image_updated_at: DateTime.now,
  # thumbnail_image: File.open('/tmp/floor1/bedroom_5_thumb.png'),
  # plan_image: File.open('/tmp/floor1/bedroom_5.png'),
  )

laurelBath2=
PlanOption.create(
  name: 'Bath 2',
  information: 'This is more descriptive text about this plan option',
  default_price: 1500,
  category: 'bathroom',
  thumbnail_image_file_name: "laurel-first-floor-plan.jpg",
  thumbnail_image_content_type: "image/jpeg",
  thumbnail_image_file_size: 167339,
  thumbnail_image_updated_at: DateTime.now,
  plan_image_file_name: "laurel-first-floor-plan.jpg",
  plan_image_content_type: "image/jpeg",
  plan_image_file_size: 167339,
  plan_image_updated_at: DateTime.now,
  # thumbnail_image: File.open('/tmp/floor1/bedroom_5_thumb.png'),
  # plan_image: File.open('/tmp/floor1/bedroom_5.png'),
  )

laurelShower=
PlanOption.create(
  name: 'Enlarged Shower',
  information: 'This is more descriptive text about this plan option',
  default_price: 2000,
  category: 'bathroom',
  thumbnail_image_file_name: "laurel-first-floor-plan.jpg",
  thumbnail_image_content_type: "image/jpeg",
  thumbnail_image_file_size: 167339,
  thumbnail_image_updated_at: DateTime.now,
  plan_image_file_name: "laurel-first-floor-plan.jpg",
  plan_image_content_type: "image/jpeg",
  plan_image_file_size: 167339,
  plan_image_updated_at: DateTime.now,
  # thumbnail_image: File.open('/tmp/floor1/bedroom_5_thumb.png'),
  # plan_image: File.open('/tmp/floor1/bedroom_5.png'),
  )

ExcludedPlanOption.create(
  plan_option: laurelCoveredPatio,
  excluded_plan_option_id: laurelExtendedCoveredPatio.id)

ExcludedPlanOption.create(
  plan_option: laurelExtendedCoveredPatio,
  excluded_plan_option_id: laurelCoveredPatio.id)

ExcludedPlanOption.create(
  plan_option: laurelBayMastBed,
  excluded_plan_option_id: laurel3FootExt.id)

ExcludedPlanOption.create(
  plan_option: laurel3FootExt,
  excluded_plan_option_id: laurelBayMastBed.id)

ExcludedPlanOption.create(
  plan_option: laurelBedroom4,
  excluded_plan_option_id: laurelFireplace.id)

ExcludedPlanOption.create(
  plan_option: laurelFireplace,
  excluded_plan_option_id: laurelBedroom4.id)

ExcludedPlanOption.create(
  plan_option: laurelBedroom4,
  excluded_plan_option_id: laurelBath2.id)

ExcludedPlanOption.create(
  plan_option: laurelBath2,
  excluded_plan_option_id: laurelBedroom4.id)

ExcludedPlanOption.create(
  plan_option: laurelFireplace,
  excluded_plan_option_id: laurelBath2.id)

ExcludedPlanOption.create(
  plan_option: laurelBath2,
  excluded_plan_option_id: laurelFireplace.id)

ExcludedPlanOption.create(
  plan_option: laurel25Garage,
  excluded_plan_option_id: laurel3Garage.id)

ExcludedPlanOption.create(
  plan_option: laurel3Garage,
  excluded_plan_option_id: laurel25Garage.id)

ExcludedPlanOption.create(
  plan_option: laurelGarage3Ext,
  excluded_plan_option_id: laurelGrage6Ext.id)

ExcludedPlanOption.create(
  plan_option: laurelGrage6Ext,
  excluded_plan_option_id: laurel3Garage.id)


Elevation.create(
  name: 'Laurel L',
  description: "Here's a brief rundown of the style of this elevation",
  price: 0,
  image_file_name: "gehan-homes-premier-laurel-l-elevation.jpg",
  image_content_type: "image/jpeg",
  image_file_size: 12425,
  image_updated_at: DateTime.now,
  # image: URI.parse('http://www.gehanhomes.com/media/43994/gehan-homes-premier-laurel-l-elevation.jpg'), 
  plan: laurel)

Elevation.create(
  name: 'Laurel M',
  description: "Here's a brief rundown of the style of this elevation",
  price: 9300,
  image_file_name: "gehan-homes-premier-laurel-m-elevation.jpg",
  image_content_type: "image/jpeg",
  image_file_size: 11572,
  image_updated_at: DateTime.now,
  # image: URI.parse('http://www.gehanhomes.com/media/43995/gehan-homes-premier-laurel-m-elevation.jpg'), 
  plan: laurel)

Elevation.create(
  name: 'Laurel O',
  description: "Here's a brief rundown of the style of this elevation",
  price: 15600,
  image_file_name: "gehan-homes-premier-laurel-o-elevation.jpg",
  image_content_type: "image/jpeg",
  image_file_size: 12096,
  image_updated_at: DateTime.now,
  # image: URI.parse('http://www.gehanhomes.com/media/43996/gehan-homes-premier-laurel-o-elevation.jpg'), 
  plan: laurel)

Elevation.create(
  name: 'Laurel P',
  description: "Here's a brief rundown of the style of this elevation",
  price: 3000,
  image_file_name: "gehan-homes-premier-laurel-p-elevation.jpg",
  image_content_type: "image/jpeg",
  image_file_size: 13121,
  image_updated_at: DateTime.now,
  # image: URI.parse('http://www.gehanhomes.com/media/43997/gehan-homes-premier-laurel-p-elevation.jpg'), 
  plan: laurel) 

# Create admin / builder / customer role
Role.create(name: "admin")
Role.create(name: "builder")
Role.create(name: "customer")

# Now for the fake data

fugazi=Builder.create name: 'Fugazi Homes'

Region.create(name: 'Northwest', builder: fugazi)
Region.create(name: 'Northeast', builder: fugazi)
Region.create(name: 'Midwest', builder: fugazi)
Region.create(name: 'Southwest', builder: fugazi)
Region.create(name: 'Deep South', builder: fugazi)
Region.create(name: 'Texas', builder: fugazi)

fugazi_collections = []
Region.where(builder: fugazi).each do |region|
  3.times { 
    fugazi_collections.push(
        create(:collection, region: region) 
    )
  }
end

fugazi_plans = []
5000.times {
  fugazi_plans.push(
    create(:plan, collection: fugazi_collections.sample)
  )
}

fugazi_plans.each do |plan|
  elevations_count = 1 + Random.rand(10)
  elevations_count.times {
    create(:elevation, plan: plan)
  }

  for story in 0..plan.min_stories.to_i
    create(:plan_image, plan: plan)
  end
end
