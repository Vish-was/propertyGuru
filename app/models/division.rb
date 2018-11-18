class Division < ApplicationRecord
  belongs_to :region
  has_many :communities, dependent: :destroy
  has_many :contacts, dependent: :destroy

  validates_presence_of :name
end