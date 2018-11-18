class Builder < ApplicationRecord
  has_many :regions, dependent: :destroy
  has_and_belongs_to_many :users#, :join_table => :builders_users
  has_many :contacts, dependent: :destroy

  has_attached_file :logo
  validates_attachment_content_type :logo, content_type: /\Aimage\/.*\z/

  validates_presence_of :name
  resourcify

  scope :name_is, -> (name_is) { where "name = ?", "#{name_is}" }

  def self.filtering_params(params)
    params.slice(:name_is)
  end
end
