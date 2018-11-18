class SavedSearch < ApplicationRecord
  belongs_to :user

  validates_presence_of :name, :criteria, :user_id
end
