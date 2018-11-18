class Region < ApplicationRecord
  belongs_to :builder
  has_many :divisions, dependent: :destroy
  has_many :collections, dependent: :destroy
  validates_presence_of :name
end
