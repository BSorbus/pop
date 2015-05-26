class Rotation < ActiveRecord::Base

  validates :insurance_id,  presence: true
  validates :rotation_date,  presence: true
  validate :next_rotation_date, on: :create


  belongs_to :insurance
  has_many :coverages, dependent: :destroy

  scope :by_insurance, ->(current_insurance_id) { where(insurance_id: current_insurance_id) }
  scope :by_rotation_date, -> { order(:rotation_date) }


  before_destroy :insurance_or_rotation_is_locked, prepend: true
  # KONIECZNIE zostaw w czasie ładowania
  after_save :push_event
  after_destroy :clean_event

  def push_event
    event = Event.find_or_create_by( url_action: "/insurances/#{self.insurance.id}/rotations/#{self.id}", user: self.insurance.user )
    event.title = "#{self.insurance.company.short} \n #{self.insurance.number}"
    event.allday = true
    event.start_date = self.rotation_date + 10.hours   
    event.end_date = self.rotation_date + 10.hours + 15.minutes
    event.color = self.rotation_lock? ? '#5cb85c' : '#f0ad4e' #@brand-success : #@brand-warning
    event.save
  end

  def clean_event
    Event.delete_all(url_action: "/insurances/#{self.insurance.id}/rotations/#{self.id}")
  end
  
  def next_rotation_date
    if insurance.rotations.where("rotation_date > :this_date", this_date: rotation_date).any? 
      errors.add(:rotation_date, " - Już jest zarejstrowana Rotacja z datą późniejszą" )
      false
    end
  end

  def insurance_or_rotation_is_locked
    analize_value = true
    if insurance.insurance_lock? 
      errors[:base] << "Polisa jest zablokowana!"
      analize_value = false
    end
    if rotation_lock? 
      errors[:base] << "Rotacja jest zablokowana!"
      analize_value = false
    end
    return analize_value
  end


  def coverages_add
    current_insurance_id = insurance.id
    current_rotation_id = id
    @prior_rotation = Rotation.where("id < :r_id AND insurance_id = :i_id", r_id: current_rotation_id, i_id: current_insurance_id).order(:id).all
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

  def groups_for_coverages_add
    #coverages_add = self.coverages_add.pluck(:group_id)
    #@groups_for_coverages_add = Group.where(id: coverages_add )
    @groups_for_coverages_add = Group.where(id: coverages_add.uniq.pluck(:group_id) )
  end

  def groups_for_coverages_remove
    @groups_for_coverages_remove = Group.where(id: coverages_remove.uniq.pluck(:group_id) )
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
# Pozwól jednak zblokować rotację    
#    if self.insurance.insurance_lock?
#      errors[:base] << "Polisa jest zablokowana!"
#      false      
#    else
      if Rotation.where(insurance: insurance, rotation_lock: false).where("rotation_date < :this_rotation", this_rotation: rotation_date).any?
        errors[:base] << "Nie można zablokować Rotacji jeżeli występuje wcześniejsza Rotacja bez blokady"
        false
      else
        self.rotation_lock = true
        self.save
        true
      end      
#    end
  end

  def unlock
    if self.insurance.insurance_lock?
      errors[:base] << "Polisa jest zablokowana!"
      false      
    else
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

end
