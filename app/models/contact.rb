class Contact < ApplicationRecord
  belongs_to :division, optional: true
  belongs_to :builder

  validates_presence_of :name, :email
  validates_inclusion_of :builder_default, in: [true, false]

  before_create :reset_default
  before_validation :set_builder

  def division_name
    division&.name
  end

  private

  def reset_default
    return unless builder_default
    Contact.where(builder_id: builder_id, builder_default: true)
           .update_all(builder_default: false)
  end

  def set_builder
    return if builder_id
    return unless division_id
    self.builder_id = division&.region&.builder_id
  end
end
