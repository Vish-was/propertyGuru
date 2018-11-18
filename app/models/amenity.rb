class Amenity < ApplicationRecord
  has_and_belongs_to_many :communities, :join_table => :communities_amenities
  validates_presence_of :name

  scope :starts_with, -> (starts_with) { where "lower(amenities.name) like ?", "#{starts_with}%".downcase}

  def self.filtering_params(params)
    params.slice(:starts_with) 
  end
end