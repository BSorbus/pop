class FamilyCoverage < ActiveRecord::Base

  validates :family_rotation_id,  presence: true
  validates :insured_id,  presence: true,  
                          :uniqueness => { :scope => [:family_rotation_id], :message => "już występuje w tej Rotacji" }  
  validates :payer_id,  presence: true

  belongs_to :family_rotation
  belongs_to :insured
  belongs_to :payer

  scope :by_family_rotation, ->(only_for_family_rotation_id) { where(family_rotation_id: only_for_family_rotation_id) }
  scope :by_insured, ->(only_for_insured_id) { where(insured_id: only_for_insured_id) }
  scope :by_payer, ->(only_for_payer_id) { where(payer_id: only_for_payer_id) }

  # po zaladowaniu odkomentuj to !!!!!!!!!!!!!!!!!!
  #before_save :family_or_family_rotation_is_locked
  #before_destroy :family_or_family_rotation_is_locked, prepend: true

  def family_or_family_rotation_is_locked
    analize_value = true
    if family_rotation.family.family_lock? 
      errors.add(:base, 'Polisa jest zablokowana!')
      #errors[:base] << "Polisa jest zablokowana!"
      analize_value = false
    end
    if family_rotation.rotation_lock? 
      errors[:base] << "Rotacja jest zablokowana!"
      analize_value = false
    end
    analize_value
  end

  def fullname
    "Ochrona w rotacji: #{family_rotation.rotation_date}, dla: #{insured.fullname}"
  end


end
