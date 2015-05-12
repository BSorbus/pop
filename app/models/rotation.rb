class Rotation < ActiveRecord::Base

  validates :rotation_date, presence: true
  validates :insurance_id,  presence: true
  validates :rotation_date,  presence: true
  validate :next_rotation_date, on: :create


  belongs_to :insurance
  has_many :coverages, dependent: :destroy

  scope :by_insurance, ->(current_insurance_id) { where(insurance_id: current_insurance_id) }
  scope :by_rotation_date, -> { order(:rotation_date) }

  before_destroy :rotation_has_coverages, prepend: true

  def next_rotation_date
    if insurance.rotations.where("rotation_date > :this_date", this_date: rotation_date).any? 
      errors.add(:rotation_date, "Już jest zarejstrowana Rotacja z datą późniejszą" )
      #errors[:base] << "Jest już zarejestrowana Rotacja z datą późniejszą"
      false
    end
  end

  def rotation_has_coverages
    if coverages.any? 
      errors[:base] << "Nie można usunąć Rotacji, która jest użyta w Ochronie"
      false
    end
  end

  def coverages_add
    current_insurance_id = insurance.id
    current_rotation_id = id
    @prior_rotation = Rotation.where("id < :r_id AND insurance_id = :i_id", r_id: current_rotation_id, i_id: current_insurance_id).order(:id).all
    #if @prior_rotation.empty? 
    #  prior_rotation_id = 0
    #else
    #  prior_rotation_id = @prior_rotation.last.id
    #end 
    prior_rotation_id = @prior_rotation.empty? ?  0 : @prior_rotation.last.id

    @coverages_add = Coverage.where("(rotation_id = :c_r) AND ('I:'||insured_id||'G:'||group_id NOT IN (SELECT 'I:'||insured_id||'G:'||group_id FROM coverages WHERE rotation_id = :p_r))", c_r: current_rotation_id, p_r: prior_rotation_id).all
  end

  def coverages_remove
    current_insurance_id = insurance.id
    current_rotation_id = id
    @prior_rotation = Rotation.where("id < :r_id AND insurance_id = :i_id", r_id: current_rotation_id, i_id: current_insurance_id).order(:id).all
    prior_rotation_id = @prior_rotation.empty? ? 0 : @prior_rotation.last.id

    @coverages_remove = Coverage.where("(rotation_id = :p_r) AND ('I:'||insured_id||'G:'||group_id NOT IN (SELECT 'I:'||insured_id||'G:'||group_id FROM coverages WHERE rotation_id = :c_r))", c_r: current_rotation_id, p_r: prior_rotation_id).all
  end

  def fullname
    "Rotacja z dnia #{rotation_date}"
  end

  def duplicate_coverages(duplicate_rotation_id)
    for_rotation_id = self.id
    for_duplicate_coverages = Coverage.where(rotation_id: duplicate_rotation_id)
    Coverage.transaction do
      for_duplicate_coverages.each do |coverage|
        new_coverage = Coverage.new(rotation_id: for_rotation_id,
                                    group_id: coverage.group_id,
                                    insured_id: coverage.insured_id,
                                    payer_id: coverage.payer_id,
                                    note: coverage.note)
        new_coverage.save
      end if for_duplicate_coverages.size > 0
    end
    # zablokuj duplikowaną rotację.
    #for_lock_rotation = Rotation.find_by(id: duplicate_rotation_id)
    @for_lock_rotation = Rotation.find(duplicate_rotation_id)
    @for_lock_rotation.rotation_lock = true
    @for_lock_rotation.save!
  end


  def lock
    if Rotation.where(insurance: insurance, rotation_lock: false).where("rotation_date < :this_rotation", this_rotation: rotation_date).any?
      errors[:base] << "Nie można zablokować Rotacji jeżeli występuje wcześniejsza Rotacja bez blokady"
      false
    else
      self.rotation_lock = true
      self.save
      true
    end
  end

  def unlock
    if Rotation.where(insurance: insurance, rotation_lock: false).where("id <> :this_rotation", this_rotation: id).any?
      errors[:base] << "Nie można odblokowywać wielu Rotacji"
      false
    else
      if Rotation.where(insurance: insurance, rotation_lock: true).where("rotation_date > :this_rotation", this_rotation: rotation_date).any?
        errors[:base] << "Nie można odblokować Rotacji jeżeli występuje późniejsza Rotacja z nałożoną blokadą"
        false
      else
        self.rotation_lock = false
        self.save
        true
      end
    end
  end

end
