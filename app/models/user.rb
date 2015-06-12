class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :trackable, :rememberable, :lockable and :omniauthable
  devise :database_authenticatable, :confirmable, :registerable, :recoverable, 
  			:timeoutable, :validatable, :authentication_keys => [:login]

  validates :agent_number, presence: true,
                          length: { in: 1..10 },
                          :uniqueness => { :case_sensitive => false }

  attr_accessor :login




  after_commit :load_example_data, on: :create, if: "id > 4"

  def load_example_data
    Rails.application.load_seed
  end




  #def login=(login)
  #  @login = login
  #end

  #def login
  #  @login || self.agent_number || self.email
  #end
 
  def self.find_for_database_authentication(warden_conditions)
    conditions = warden_conditions.dup
    if login = conditions.delete(:login)
      #where(conditions).where(["lower(agent_number) = lower(:value)", { :value => login }]).first
      #where(conditions).where(["lower(email) = lower(:value)", { :value => login }]).first
      where(conditions).where(["lower(email) = lower(:value) OR lower(agent_number) = lower(:value)", { :value => login }]).first
    else
      where(conditions).first
    end
  end

  def self.find_first_by_auth_conditions(warden_conditions)
    conditions = warden_conditions.dup
    if login = conditions.delete(:login)
      #where(conditions).where(["lower(agent_number) = lower(:value)", { :value => login }]).first
      #where(conditions).where(["lower(email) = lower(:value)", { :value => login }]).first
      where(conditions).where(["lower(email) = lower(:value) OR lower(agent_number) = lower(:value)", { :value => login }]).first
    else
      where(conditions).first
    end
  end

  has_many :companies, dependent: :destroy  
  has_many :individuals, dependent: :destroy
  has_many :insurances, dependent: :destroy
  has_many :rotations, through: :insurances
  has_many :families, dependent: :destroy
  has_many :family_rotations, through: :families

  has_many :events
end

