class Collection < ApplicationRecord
  belongs_to :region
  has_many :plans, dependent: :destroy
  validates_presence_of :name
end
