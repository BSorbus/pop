class Family < ActiveRecord::Base

  include ApplicationHelper

  validates :number, presence: true,
                    length: { in: 1..19 },
                    :uniqueness => { :case_sensitive => false, :scope => [:user_id] }
  validates :concluded, presence: true
  validates :valid_from, presence: true
  validates :pay, inclusion: { in: %w(K M P R) }

  belongs_to :company
  belongs_to :user
  has_many :family_rotations, dependent: :destroy
  has_many :family_coverages, through: :family_rotations

  scope :by_concluded, -> { order(:concluded) }
  
  scope :by_user, ->(current_login_user_id) { where(user_id: current_login_user_id) }
  scope :by_company, ->(current_company_id) { where(company_id: current_company_id) }

	before_save { self.protection_variant = protection_variant.upcase }

  def fullname
    "Rodzina #{number}, z #{concluded}"
  end

  def pay_name
    case pay
    when 'K'
      'Kwartalna'
    when 'M'
      'Miesięczna'
    when 'P'
      'Półroczna'
    when 'R'
      'Jednorazowa'
    else
      'family.pay - Error !'
    end  
  end

  def for_popover_data
    "z dnia: #{concluded} <br />
    ważna: #{valid_from} <br />
     ... do: #{applies_to} <br />
    składka: #{pay_name} <br />
    wniosek: #{proposal_number} <br />
    wariant: #{protection_variant} <br />
    SU: #{with_delimiter_and_separator(assurance)} <br />
    blokada: #{family_lock? ? '<div class="glyphicon glyphicon-lock"></div>' : ' '}"
  end

  def lock
    self.family_lock = true
    self.save!
    true
  end

  def unlock
    self.family_lock = false
    self.save!
    true
  end


end
