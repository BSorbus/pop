class Company < ActiveRecord::Base

  validates :user,  presence: true

  validates :short, presence: true,
                    length: { in: 1..10 },
                    :uniqueness => { :case_sensitive => false, :scope => [:user_id] }
  validates :name, presence: true,
                    length: { in: 1..100 }
  validates :address_city, presence: true,
                    length: { in: 1..50 }
  validates :address_city, presence: true,
                    length: { in: 1..50 }
  validates :nip, length: { in: 10..13 }, allow_blank: true
  validates :regon, length: { in: 7..9 }, allow_blank: true
  validates :pesel, length: { is: 11 }, allow_blank: true

  belongs_to :user
  has_many :insurances, dependent: :destroy
  has_many :rotations, through: :insurances
  has_many :coverages, through: :rotations
  has_many :groups, through: :insurances
  has_many :discounts, through: :groups
  has_many :families, dependent: :destroy
  has_many :family_rotations, through: :families
  has_many :family_coverages, through: :family_rotations
  has_many :company_histories

  has_many :documents, as: :documentable, :source_type => "Company", dependent: :destroy

  before_save { self.short = short.upcase }
  before_destroy :company_has_insurances_or_families, prepend: true

  scope :by_short, -> { order(:short) }
  scope :by_user, ->(current_login_user_id) { where(user_id: current_login_user_id) }


  def company_has_insurances_or_families
    analize_value = true
    if Insurance.where(company_id: id).any? 
      errors[:base] << "Nie można usunąć Firmy, która ma przypisane Polisy NNW"
      analize_value = false
    end
    if Family.where(company_id: id).any? 
      errors[:base] << "Nie można usunąć Firmy, która ma przypisane Polisy Rodzina"
      analize_value = false
    end
    analize_value
  end


  def fullname
    "#{short}, #{name}"
  end

  def street_house_number
    if address_number.blank?
      "#{address_street} #{address_house}"
    else
      "#{address_street} #{address_house}/#{address_number}"
    end
  end

  def postal_code_city
    "#{address_postal_code} #{address_city}"
  end
  
  def for_popover_data
    "#{name} <br />
    #{address_postal_code} #{address_city} <br />
    #{address_street} #{address_house} #{address_number} <br />
    NIP: #{nip} <br />
    REGON: #{regon} <br />
    PESEL: #{pesel} <br />
    tel: #{phone}"
  end

  def insurances_cached
    @insurances_cached ||= insurances.by_concluded
  end

  def families_cached
    @families_cached ||= families.by_concluded
  end

#  def items_cached(has_administrator_privileges)
#    if has_administrator_privileges
#      @items_cached ||= items.data_by_number
#    else
#      @items_cached ||= items.only_activity.data_by_number
#    end
#  end
 
end
