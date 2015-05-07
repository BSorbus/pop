class Insurance < ActiveRecord::Base

  validates :number, presence: true,
                    length: { in: 1..19 },
                    :uniqueness => { :case_sensitive => false, :scope => [:user_id] }
  validates :concluded, presence: true
  validates :valid_from, presence: true
  validates :pay, inclusion: { in: %w(K M P R) }

  belongs_to :company
  belongs_to :user
  has_many :groups, dependent: :destroy
  has_many :rotations, dependent: :destroy
  has_many :discounts, through: :groups
  has_many :coverages, through: :groups
  has_many :coverages, through: :rotations

  scope :by_concluded, -> { order(:concluded) }
  
  scope :by_user, ->(current_login_user_id) { where(user_id: current_login_user_id) }
  scope :by_company, ->(current_company_id) { where(company_id: current_company_id) }

  before_destroy :insurance_has_rotations_or_groups, prepend: true

  def insurance_has_rotations_or_groups
    analize_value = true
    #if Rotation.where(insurance_id: id).any? 
    if rotations.any? 
      errors[:base] << "Nie można usunąć Polisy, która ma przypisane Rotacje"
      analize_value = false
    end
    #if Group.where(insurance_id: id).any? 
    if groups.any? 
      errors[:base] << "Nie można usunąć Polisy, która ma przypisane Grupy"
      analize_value = false
    end
    return analize_value
  end
  

  def fullname
    "NNW #{number}, z #{concluded}"
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
      'insurance.pay - Error !'
    end  
  end

  def for_popover_data
    "z dnia: #{concluded} <br />
    ważna: #{valid_from} <br />
     ... do: #{applies_to} <br />
    składka: #{pay_name}"
  end

  def reorganize_group_numbers
    @groups_for_numbering = groups.order(:tariff_fixed, :full_range, :risk_group, :assurance, :treatment, :ambulatory, :hospital, :infarct, :inability)
    Group.transaction do

      @groups_for_numbering.each_with_index do |group, index|
        Group.update(group.id, number: index+1)
      end
      
    end
    true
  end


end

