class User < ActiveRecord::Base
  rolify
  include DeviseTokenAuth::Concerns::User
  include Filterable
  
  has_many :saved_plans, dependent: :destroy
  has_many :saved_searches, dependent: :destroy
  has_many :plans, through: :saved_plans
  has_many :user_viewed_plans

  has_many :viewed_plans , through: :user_viewed_plans, source: :plan

  has_and_belongs_to_many :builders#, :join_table => :builders_users

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :confirmable, :lockable, :timeoutable, :omniauthable

  validates_presence_of :email, :profile

  scope :email_like, -> (email_substring) { where "email ilike ?", "%#{email_substring}%" }
  scope :name_like, -> (name_substring) { where "name ilike ?", "%#{name_substring}%" }

  def self.filtering_params(params)
    params.slice(:email_like, :name_like)
  end

  def role_names
    roles.map(&:name)
  end
 
end
