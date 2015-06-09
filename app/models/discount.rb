class Discount < ActiveRecord::Base

  validates :category,  presence: true 
  validates :discount_increase, numericality: true,  presence: true 
  validates :group_id,  presence: true

  belongs_to :group, touch: true

  scope :by_minus_value, -> { where("discount_increase < 0") }
  scope :by_plus_value, -> { where("discount_increase > 0") }

  # po zaladowaniu odkomentuj to !!!!!!!!!!!!!!!!!!
  #before_destroy :discount_in_group_used_in_locked_rotation
  #after_destroy :touch_parent_group_after_commit
  #before_save :discount_in_group_used_in_locked_rotation
  #after_save :touch_parent_group_after_commit


  def discount_in_group_used_in_locked_rotation
    if group.group_used_in_locked_rotation 
      errors[:base] << "Grupa użyta w zablokowanej Rotacji!"
      false
    end   
  end

  def insurance_has_insurance_lock
    if group.insurance.insurance_lock? 
      errors[:base] << "Polisa jest zablokowana!"
      false
    end   
  end

  def touch_parent_group_after_commit
    group.set_group_values if (group.quotation != 'C') # Nie wyliczaj automatycznie składek dla kwotacji Niestandardowej
    group.save
  end

  def fullname
    "Zniżka/Zwyżka: #{category_name}"
  end

  def category_name
    case category
    when 'IL'
      "IL - Zniżka grupowa"
    when 'IP'
      "IP - Zniżka z tytułu wykupienia min 3 świadczeń dodatkowych"
    when 'OK'
      "OK - Zwyżka z tytułu płatności ratalnej"
    when 'IN'
      "IN - Zniżka dodatkowa"
    when 'BK'
      "BK - Zniżka z tytułu bezszkodowej kontynuacji"
    when 'GR'
      "GR - Zniżka z tytułu posiadania polisy 647 lub 750"
    else
      category
    end  
  end

end
