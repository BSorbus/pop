class User < ActiveRecord::Base
  enum role: [:user, :vip, :admin]
  after_initialize :set_default_role, :if => :new_record?

  # Include default devise modules. Others available are:
  # :trackable, :rememberable, :lockable and :omniauthable
  devise :database_authenticatable, :confirmable, :registerable, :recoverable, 
  			:timeoutable, :validatable, :trackable, :authentication_keys => [:login]

  validates :agent_number, presence: true,
                          length: { in: 1..10 },
                          :uniqueness => { :case_sensitive => false }

  before_destroy :del_cascade, prepend: true

  attr_accessor :login


  after_commit :load_example_data, on: :create, if: "id > 4"

  def set_default_role
    self.role ||= :user
  end
  
  def load_example_data
    Rails.application.load_seed
  end

  def del_cascade
    @insurances = self.insurances
    @insurances.each do |i|
      @rotations = i.rotations
      @rotations.each do |r|
        r.coverages.delete_all
      end
      @rotations.delete_all

      @groups = i.groups
      @groups.each do |g|
        g.discounts.delete_all
      end
      @groups.delete_all
    end
    @insurances.delete_all

    @families = self.families
    @families.each do |f|
      @family_rotations = f.family_rotations
      @family_rotations.each do |fr|
        fr.family_coverages.delete_all
      end
      @family_rotations.delete_all     
    end
    @families.delete_all
    companies.delete_all
    individuals.delete_all
    true
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

