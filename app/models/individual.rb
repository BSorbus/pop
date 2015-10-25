class Individual < ActiveRecord::Base

  validates :user,  presence: true

  validates :first_name, presence: true,
                    length: { in: 1..30 }
  validates :last_name, presence: true,
                    length: { in: 1..80 }
  validates :address_city, presence: true,
                    length: { in: 1..50 }
  validates :pesel, length: { is: 11 }, numericality: true, 
                    :uniqueness => { :scope => [:user_id] }, allow_blank: true
  validates :birth_date, presence: true
  validate :check_pesel_and_birth_date, unless: "pesel.blank?"

  require 'pesel'

  def check_pesel_and_birth_date
    p = Pesel.new(pesel)
    errors.add(:pesel, ' - Błędny numer') unless p.valid?
    if p.valid? 
       errors.add(:birth_date, " niezgodna z datą zapisaną w numerze PESEL (#{p.birth_date})") unless p.birth_date == birth_date
    end
  end

  belongs_to :user
  has_many :insureds, foreign_key: :insured_id, class_name: "Coverage", dependent: :destroy 
  has_many :payers, foreign_key: :payer_id, class_name: "Coverage", dependent: :destroy 
  has_many :individual_histories

  has_many :documents, as: :documentable, :source_type => "Individual", dependent: :destroy

  before_destroy :individual_has_coverages_or_family_coverages, prepend: true

  scope :by_user, ->(current_login_user_id) { where(user_id: current_login_user_id) }

  scope :finder_by_user, ->(q, current_login_user_id) { where("(individuals.last_name ilike :q or individuals.first_name ilike :q 
      or individuals.pesel like :q) and (individuals.user_id = :u)", q: "%#{q}%", u: current_login_user_id ) }

  #scope :finder, lambda { |q| where("upper(individuals.last_name) ilike :q or 
  #                                   upper(individuals.first_name) ilike :q or 
  #                                   individuals.pesel like :q", q: "%#{q}%" ) }

  # odblokuj, gdy w kontrolerze cesz użyc .as_json
  def as_json(options)
    { id: id, last_name: last_name, first_name: first_name, pesel: pesel, fullname: fullname }
  end

  def individual_has_coverages_or_family_coverages
    analize_value = true
    if Coverage.where(insured_id: id).any? || FamilyCoverage.where(insured_id: id).any? 
      errors[:base] << "Nie można usunąć Osoby, która jest przypisana jako Ubezpieczony"
      analize_value = false
    end
    if Coverage.where(payer_id: id).any? || FamilyCoverage.where(payer_id: id).any? 
      errors[:base] << "Nie można usunąć Osoby, która jest przypisana jako Płatnik"
      analize_value = false
    end
    analize_value
  end


  def fullname
    "#{last_name} #{first_name}, #{address_city}, #{pesel}"
  end

  def lastfirstname
    "#{last_name} #{first_name}"
  end

  def for_popover_data
    "#{address_postal_code} #{address_city} <br />
    #{address_street} #{address_house} #{address_number} <br />
    data urodzenia: #{birth_date} <br />
    PESEL: #{pesel} <br />
    zawód: #{profession} <br />
    tel: #{phone}"
  end  
end
