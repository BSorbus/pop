class Company < ActiveRecord::Base

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
  has_many :groups, through: :insurances
  has_many :company_histories

  scope :by_short, -> { order(:short) }
  scope :by_user, ->(current_login_user_id) { where(user_id: current_login_user_id) }

  before_save { self.short = short.upcase }
  before_destroy :company_has_insurances, prepend: true

  def company_has_insurances
    if Insurance.where(company_id: id).any? 
      errors[:base] << "Nie można usunąć Firmy, która ma przypisane Polisy"
      false
    end
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

#  def items_cached(has_administrator_privileges)
#    if has_administrator_privileges
#      @items_cached ||= items.data_by_number
#    else
#      @items_cached ||= items.only_activity.data_by_number
#    end
#  end
 
end