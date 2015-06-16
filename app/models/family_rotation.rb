class FamilyRotation < ActiveRecord::Base

  validates :family,  presence: true

  validates :rotation_date,  presence: true
  # po zaladowaniu odkomentuj to !!!!!!!!!!!!!!!!!!
  #validate :next_rotation_date, on: :create


  belongs_to :family
  has_many :family_coverages, dependent: :destroy
  has_many :family_rotation_histories

  scope :by_family, ->(current_family_id) { where(family_id: current_family_id) }
  scope :by_rotation_date, -> { order(:rotation_date) }

  # po zaladowaniu odkomentuj to !!!!!!!!!!!!!!!!!!
  #before_destroy :family_or_family_rotation_is_locked, prepend: true
  # KONIECZNIE zostaw w czasie ładowania
  after_save :push_event
  after_destroy :clean_event

  def push_event
    event = Event.find_or_create_by( url_action: "/families/#{family.id}/family_rotations/#{id}", user: self.family.user )
    event.title = "#{family.company.short} \n #{family.number}"
    event.allday = true
    event.start_date = self.rotation_date + 10.hours   
    event.end_date = self.rotation_date + 10.hours + 15.minutes
    event.color = self.rotation_lock? ? '#5cb85c' : '#f0ad4e' #@brand-success : #@brand-warning
    event.save
  end

  def clean_event
    Event.delete_all(url_action: "/families/#{family.id}/family_rotations/#{id}")
  end
  
  def next_rotation_date
    if family.family_rotations.where("rotation_date > :this_date", this_date: rotation_date).any? 
      errors.add(:rotation_date, " - Już jest zarejstrowana Rotacja z datą późniejszą" )
      false
    end
  end  

  def family_or_family_rotation_is_locked
    analize_value = true
    if family.family_lock? 
      errors[:base] << "Polisa jest zablokowana!"
      analize_value = false
    end
    if rotation_lock? 
      errors[:base] << "Rotacja jest zablokowana!"
      analize_value = false
    end
    return analize_value
  end

  def family_coverages_add
    current_family_id = family.id
    current_family_rotation_id = id
    @prior_rotation = FamilyRotation.where("id < :r_id AND family_id = :i_id", r_id: current_family_rotation_id, i_id: current_family_id).order(:id).all
    prior_rotation_id = @prior_rotation.empty? ?  0 : @prior_rotation.last.id

    @coverages_add = FamilyCoverage.where("(family_rotation_id = :c_r) AND (insured_id NOT IN (SELECT insured_id FROM family_coverages WHERE family_rotation_id = :p_r))", c_r: current_family_rotation_id, p_r: prior_rotation_id).all
  end

  def family_coverages_remove
    current_family_id = family.id
    current_family_rotation_id = id
    @prior_rotation = FamilyRotation.where("id < :r_id AND family_id = :i_id", r_id: current_family_rotation_id, i_id: current_family_id).order(:id).all
    prior_rotation_id = @prior_rotation.empty? ? 0 : @prior_rotation.last.id

    @coverages_remove = FamilyCoverage.where("(family_rotation_id = :p_r) AND (insured_id NOT IN (SELECT insured_id FROM family_coverages WHERE family_rotation_id = :c_r))", c_r: current_family_rotation_id, p_r: prior_rotation_id).all
  end

  def fullname
    "Rotacja z dnia #{rotation_date}"
  end

  def lock
# Pozwól jednak zblokować rotację    
#    if family.family_lock?
#      errors[:base] << "Polisa jest zablokowana!"
#      false      
#    else
      if FamilyRotation.where(family: family, rotation_lock: false).where("rotation_date < :this_rotation", this_rotation: rotation_date).any?
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
    if family.family_lock?
      errors[:base] << "Polisa jest zablokowana!"
      false      
    else
      if FamilyRotation.where(family: family, rotation_lock: false).where("id <> :this_rotation", this_rotation: id).any?
        errors[:base] << "Nie można odblokowywać wielu Rotacji"
        false
      else
        if FamilyRotation.where(family: family, rotation_lock: true).where("rotation_date > :this_rotation", this_rotation: rotation_date).any?
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
