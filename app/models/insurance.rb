class Insurance < ActiveRecord::Base

  validates :user,  presence: true
  validates :company,  presence: true

  validates :number, presence: true,
                    length: { in: 1..19 },
                    :uniqueness => { :case_sensitive => false, :scope => [:user_id] }
  validates :concluded, presence: true
  validates :valid_from, presence: true
  validates :pay, inclusion: { in: %w(K M P R) }

  belongs_to :company
  belongs_to :user
  has_many :rotations, dependent: :destroy
  has_many :discounts, through: :groups
  has_many :groups, dependent: :destroy
  has_many :coverages, through: :groups
  has_many :coverages, through: :rotations
  has_many :insurance_histories

  scope :by_concluded, -> { order(:concluded) }
  
  scope :by_user, ->(current_login_user_id) { where(user_id: current_login_user_id) }
  scope :by_company, ->(current_company_id) { where(company_id: current_company_id) }

  # po zaladowaniu odkomentuj to !!!!!!!!!!!!!!!!!!
  #before_destroy :insurance_is_locked_or_has_locked_rotation, prepend: true


  def insurance_is_locked_or_has_locked_rotation
    analize_value = true
    if insurance_lock? 
      errors[:base] << "Polisa jest zablokowana!"
      analize_value = false
    end
    #if Rotation.where(insurance_id: id).any? 
    if rotations.where(rotation_lock: true).any? 
      errors[:base] << "Nie można usunąć Polisy, która ma zablokowane Rotacje"
      analize_value = false
    end
    analize_value
  end

  def fullname
    "NNW #{number}, z #{concluded}"
  end

  def nu_filename
    if self.nil?
      "brak polisy"
    else
      if rotations.empty?
        "NU_#{number.last(12)}_brak_rotacji.txt"
      else
        "NU_#{number.last(12)}_#{rotations.last.rotation_date.strftime("%Y%m%d").last(6)}.txt"
      end
    end
  end

  def n_filename
    if self.nil?
      "brak polisy"
    else
      if rotations.empty?
        "N_#{number.last(12)}_brak_rotacji.txt"
      else
        "N_#{number.last(12)}_#{rotations.last.rotation_date.strftime("%Y%m%d").last(6)}.txt"
      end
    end
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
    składka: #{pay_name} <br />
    blokada: #{insurance_lock? ? '<div class="glyphicon glyphicon-lock"></div>' : ' '}"
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

  def duplicate_all_data_from_last_rotation(duplicate_insurance_id)
    old_rotation = Insurance.find(duplicate_insurance_id).rotations.last

    Rotation.transaction do
      # duplicate last rotation
      new_rotation = Rotation.find(old_rotation.id).dup
      new_rotation.insurance_id = self.id
      new_rotation.rotation_lock = false
      new_rotation.rotation_date = Time.zone.today
      new_rotation.save

      Group.transaction do
        # duplicate groups
        old_rotation.insurance.groups.each do |old_group|
          new_group = Group.find(old_group.id).dup
          new_group.insurance = new_rotation.insurance
          new_group.save

          Discount.transaction do
            # duplicate discounts 
            old_group.discounts.each do |old_discount|
              new_discount = Discount.find(old_discount.id).dup
              new_discount.group = new_group
              new_discount.save          
            end # ./ old_group.discounts.each
          end # ./ Discount.transaction do


          Coverage.transaction do
            # duplicate coverages 
            old_group.coverages.where(rotation: old_rotation).each do |old_coverage|
              new_coverage = Coverage.find(old_coverage.id).dup
              new_coverage.group = new_group
              new_coverage.rotation = new_rotation
              new_coverage.save          
            end # ./ old_group.coverages.where(rotation: old_rotation).each
          end # ./ Coverage.transaction do



        end # ./ old_rotation.insurance.groups.each
      end # ./ Group.transaction do
    end # ./ Rotation.transaction do

    #self.reorganize_group_numbers ???

  end 


  def lock
    self.insurance_lock = true
    self.save!
    true
  end

  def unlock
    self.insurance_lock = false
    self.save!
    true
  end


end

