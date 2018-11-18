class Lot < ApplicationRecord
  belongs_to :community

  has_and_belongs_to_many :plans, :join_table => :plans_lots

  validates_presence_of :latitude, :longitude, :price
end
