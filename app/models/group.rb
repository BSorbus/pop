class Group < ActiveRecord::Base

  validates :quotation,  presence: true, inclusion: { in: ['A', 'B', 'C', 'D'] }
  validates :assurance, numericality: { greater_than: 0 } 

  validate  :check_modulo
  validate  :check_unique
  
  def check_modulo
    if (['A', 'B']).include? quotation 
      errors.add(:assurance, ' - Wartość musi być wielokrotnością "5000"') if ((assurance % 5000) != 0)
      errors.add(:treatment, ' - Wartość musi być wielokrotnością "1000"') if ((treatment % 1000) != 0)
      errors.add(:hospital, ' - Wartość musi być wielokrotnością "10"') if ((hospital % 10) != 0)
      errors.add(:infarct, ' - Wartość musi być wielokrotnością "1000"') if ((infarct % 1000) != 0)
      errors.add(:inability, ' - Wartość musi być wielokrotnością "5000"') if ((inability % 5000) != 0)
    elsif quotation == 'C'
      errors.add(:assurance, ' - Wartość musi być wielokrotnością "500"') if ((assurance % 500) != 0)
      errors.add(:treatment, ' - Wartość musi być wielokrotnością "500"') if ((treatment % 500) != 0)
      errors.add(:hospital, ' - Wartość musi być wielokrotnością "5"') if ((hospital % 5) != 0)
      errors.add(:infarct, ' - Wartość musi być wielokrotnością "500"') if ((infarct % 500) != 0)
      errors.add(:inability, ' - Wartość musi być wielokrotnością "500"') if ((inability % 500) != 0)
    end  
  end

  def check_unique
    errors.add(:base, ' Grupa o takich parametrach już istnieje') if
      Group.where( insurance: insurance_id, 
                  quotation: quotation,
                  tariff_fixed: tariff_fixed,
                  full_range: full_range,
                  risk_group: risk_group, 
                  assurance: assurance,
                  treatment: treatment,
                  ambulatory: ambulatory,
                  hospital: hospital,
                  infarct: infarct,
                  inability: inability,
                  death_100_percent: death_100_percent ).where.not(id: id).any?
  end

  belongs_to :insurance
  has_many :discounts, dependent: :destroy, autosave: true
  has_many :coverages, dependent: :destroy

  scope :by_insurance, ->(current_insurance_id) { where(insurance_id: current_insurance_id) }
  scope :by_number, -> { order(:number) }

  # po zaladowaniu odkomentuj to !!!!!!!!!!!!!!!!!!
  #before_save {self.number = insurance.groups.size + 1 if (self.number.nil? or self.number == 0) } 
  #before_save :used_in_locked_rotation 
  #before_destroy :group_has_coverages, prepend: true

  def used_in_locked_rotation
    if group_used_in_locked_rotation 
      errors[:base] << "Grupa użyta w zablokowanej Rotacji!"
      false
    end   
  end

  def group_has_coverages
    if coverages.any? 
      errors[:base] << "Nie można usunąć Grupy, która jest użyta w Ochronie"
      false
    end
  end

  def group_used_in_locked_rotation
    Coverage.joins(:rotation).by_group(id).references(:rotation).where(rotations: {rotation_lock: true}).any?
  end

  def fullname
    "Grupa nr #{number}"
  end

  def fullinfo
    "Grupa Nr #{number}, GR: #{risk_group}, 
    SU: #{with_delimiter_and_separator(assurance)}, 
    KL: #{with_delimiter_and_separator(treatment)}, 
    ZA: #{with_delimiter_and_separator(ambulatory)}, 
    ZSZ: #{with_delimiter_and_separator(hospital)}, 
    ZS/UM: #{with_delimiter_and_separator(infarct)}, 
    TNP: #{with_delimiter_and_separator(inability)}, 
    S100%: #{death_100_percent? ? 'Tak' : 'Nie'}, 
    Skł.mies: #{with_delimiter_and_separator(sum_after_monthly)}"
  end

  def fullinfo_for_pdf
    info_result  = "SU:#{without_separator_and_zero(assurance)} "
    info_result += "KL:#{without_separator_and_zero(treatment)} " if treatment > 0.00
    info_result += "ZA:#{without_separator_and_zero(ambulatory)} " if ambulatory > 0.00
    info_result += "ZSZ:#{without_separator_and_zero(hospital)} " if hospital > 0.00
    info_result += "ZS/UM:#{without_separator_and_zero(infarct)} " if infarct > 0.00
    info_result += "TNP:#{without_separator_and_zero(inability)}" if inability > 0.00
    return info_result
  end

  def quotation_name
    case quotation
    when 'A'
      'Standardowa'
    when 'B'
      'Specjalna'
    when 'C'
      'Niestandardowa'
    when 'D'
      'Rodzinna'
    else
      'Error !'
    end  
  end

  def tariff_fixed_name
    tariff_fixed? ? 'Stałych' : 'Proporcjonalnych'
  end

  def full_range_name
    full_range? ? 'Pełny' : 'Ograniczony'
  end

  def sum_after_year
    sum_after_monthly*12
  end

  def double_assurance
    assurance*2
  end

  def contribution
    case insurance.pay
    when 'K'
      "#{with_delimiter_and_separator(sum_after_monthly*3)}  płatna kwartalnie"
    when 'M'
      "#{with_delimiter_and_separator(sum_after_monthly)}  płatna miesięcznie"
    when 'P'
      "#{with_delimiter_and_separator(sum_after_monthly*6)}  płatna półrocznie"
    when 'R'
      "#{with_delimiter_and_separator(sum_after_monthly*12)}  płatna jednorazowo"
    else
      "insurance.pay - Error !"
    end   
  end

  def duplicate_discounts(duplicate_group_id)
    for_group_id = self.id
    for_duplicate_discounts = Discount.where(group_id: duplicate_group_id)
    Discount.transaction do
      for_duplicate_discounts.each do |discount|
        new_discount = Discount.new(group_id: for_group_id,
                                    category: discount.category,
                                    description: discount.description,
                                    discount_increase: discount.discount_increase)
        new_discount.save
      end if for_duplicate_discounts.size > 0
    end
  end

  def insurance_death_val
    death_100_percent == true ? assurance : assurance/2
  end

  def insurance_training_val
    assurance/4 < 5000 ? assurance/4 : 5000.00
  end

  def insurance_infarct30_val
    5000.00
  end


  def contribution_for_assurance_value
    (assurance/500)*contribution_for_each_500_assurance.tariff_value
  end
  def contribution_for_each_500_assurance
#    Tariff.find_by('tariffs.quotation ILIKE ?', "%#{quotation}%")
                    #["user_name = :u", { u: user_name }]
#    Tariff.where( category: "SU", 
#                  tariff_fixed: tariff_fixed, 
#                  full_range: full_range).where("tariffs.quotation ILIKE :q AND tariffs.condition_str ILIKE :rg", 
#                    q: "%#{quotation}%", rg: "%#{risk_group}%" ) 

# to jest dobrze, ale zmieniam, by było jednakowo
#    Tariff.where( category: "SU", tariff_fixed: tariff_fixed
#                ).where("tariffs.quotation ILIKE :q AND tariffs.risk_group ILIKE :rg", 
#                  q: "%#{quotation}%", rg: "%#{risk_group}%" ).first 

    Tariff.find_by("((tariffs.category = :c) OR (tariffs.category IS NULL)) AND
                    ((tariffs.quotation ILIKE :q) OR (tariffs.quotation IS NULL)) AND 
                    ((tariffs.tariff_fixed = :tf) OR (tariffs.tariff_fixed IS NULL)) AND 
                    ((tariffs.full_range = :fr) OR (tariffs.full_range IS NULL)) AND 
                    ((tariffs.risk_group ILIKE :rg) OR (tariffs.risk_group IS NULL)) AND 
                    ((tariffs.pay = :p) OR (tariffs.pay IS NULL)) AND 
                    ((tariffs.informal_group = :ig) OR (tariffs.informal_group IS NULL))", 
                      c: "SU", q: "%#{quotation}%", tf: tariff_fixed, fr: full_range, rg: "%#{risk_group}%", 
                      p: insurance.pay, ig: insurance.company.informal_group ) 

  end


  # składka za LECZENIE 
  # liczy się x stawka dla kazdego 1000 w kwotacji STANDARDOWEJ
  # ale dla uproszczenia i zmiejszenia liczby wpisów w tabeli tariff liczę zawsze dzieląc przez 500
  def contribution_for_treatment_value
    treatment == 0 ? 0.00 : (treatment/500)*contribution_for_each_500_treatment.tariff_value
  end
  def contribution_for_each_500_treatment
    Tariff.find_by("((tariffs.category = :c) OR (tariffs.category IS NULL)) AND
                    ((tariffs.quotation ILIKE :q) OR (tariffs.quotation IS NULL)) AND 
                    ((tariffs.tariff_fixed = :tf) OR (tariffs.tariff_fixed IS NULL)) AND 
                    ((tariffs.full_range = :fr) OR (tariffs.full_range IS NULL)) AND 
                    ((tariffs.risk_group ILIKE :rg) OR (tariffs.risk_group IS NULL)) AND 
                    ((tariffs.pay = :p) OR (tariffs.pay IS NULL)) AND 
                    ((tariffs.informal_group = :ig) OR (tariffs.informal_group IS NULL))", 
                      c: "LE", q: "%#{quotation}%", tf: tariff_fixed, fr: full_range, rg: "%#{risk_group}%", 
                      p: insurance.pay, ig: insurance.company.informal_group ) 
  end


  def contribution_for_ambulatory_value
    0.00
  end


  # składka za SZPITAL 
  def contribution_for_hospital_value
    hospital == 0 ? 0.00 : (hospital/5)*contribution_for_each_5_hospital.tariff_value
  end
  def contribution_for_each_5_hospital
    Tariff.find_by("((tariffs.category = :c) OR (tariffs.category IS NULL)) AND
                    ((tariffs.quotation ILIKE :q) OR (tariffs.quotation IS NULL)) AND 
                    ((tariffs.tariff_fixed = :tf) OR (tariffs.tariff_fixed IS NULL)) AND 
                    ((tariffs.full_range = :fr) OR (tariffs.full_range IS NULL)) AND 
                    ((tariffs.risk_group ILIKE :rg) OR (tariffs.risk_group IS NULL)) AND 
                    ((tariffs.pay = :p) OR (tariffs.pay IS NULL)) AND 
                    ((tariffs.informal_group = :ig) OR (tariffs.informal_group IS NULL))", 
                      c: "SZ", q: "%#{quotation}%", tf: tariff_fixed, fr: full_range, rg: "%#{risk_group}%", 
                      p: insurance.pay, ig: insurance.company.informal_group ) 
  end


  # składka za ZAWAŁ/UDAR 
  def contribution_for_infarct_value
    infarct == 0 ? 0.00 : (infarct/500)*contribution_for_each_500_infarct.tariff_value
  end
  def contribution_for_each_500_infarct
    Tariff.find_by("((tariffs.category = :c) OR (tariffs.category IS NULL)) AND
                    ((tariffs.quotation ILIKE :q) OR (tariffs.quotation IS NULL)) AND 
                    ((tariffs.tariff_fixed = :tf) OR (tariffs.tariff_fixed IS NULL)) AND 
                    ((tariffs.full_range = :fr) OR (tariffs.full_range IS NULL)) AND 
                    ((tariffs.risk_group ILIKE :rg) OR (tariffs.risk_group IS NULL)) AND 
                    ((tariffs.pay = :p) OR (tariffs.pay IS NULL)) AND 
                    ((tariffs.informal_group = :ig) OR (tariffs.informal_group IS NULL))", 
                      c: "ZU", q: "%#{quotation}%", tf: tariff_fixed, fr: full_range, rg: "%#{risk_group}%", 
                      p: insurance.pay, ig: insurance.company.informal_group ) 
  end


  # składka za TRWAŁA NIEZDOLNOŚĆ 
  def contribution_for_inability_value
    inability == 0 ? 0.00 : (inability/500)*contribution_for_each_500_inability.tariff_value
  end
  def contribution_for_each_500_inability
    Tariff.find_by("((tariffs.category = :c) OR (tariffs.category IS NULL)) AND
                    ((tariffs.quotation ILIKE :q) OR (tariffs.quotation IS NULL)) AND 
                    ((tariffs.tariff_fixed = :tf) OR (tariffs.tariff_fixed IS NULL)) AND 
                    ((tariffs.full_range = :fr) OR (tariffs.full_range IS NULL)) AND 
                    ((tariffs.risk_group ILIKE :rg) OR (tariffs.risk_group IS NULL)) AND 
                    ((tariffs.pay = :p) OR (tariffs.pay IS NULL)) AND 
                    ((tariffs.informal_group = :ig) OR (tariffs.informal_group IS NULL))", 
                      c: "TN", q: "%#{quotation}%", tf: tariff_fixed, fr: full_range, rg: "%#{risk_group}%", 
                      p: insurance.pay, ig: insurance.company.informal_group ) 
  end


  def multiplier_for_death_100_percent_value
    # "A"-Standardowa, "B"-Specjalna, "C"-Niestandardowa
    case quotation
    when 'A'
      multiplier_for_death_100_percent_A_quotation
    when 'B'
      multiplier_for_death_100_percent_B_quotation
    when 'C'
      multiplier_for_death_100_percent_C_quotation
    else
      0.00
    end
  end

  def multiplier_for_death_100_percent_A_quotation
    if death_100_percent?
      if (['A', 'B']).include? risk_group 
        tariff_fixed ? 1.35 : 1.25
      else
        1.00
      end
    else
      1.00
    end
  end

  def multiplier_for_death_100_percent_B_quotation
    death_100_percent ? 3.20/2.60 : 1.00
  end

  def multiplier_for_death_100_percent_C_quotation
    if death_100_percent?
      tariff_fixed ? 1.35 : 1.25
    else
      1.00
    end
  end


  def set_group_values
    multiplier = multiplier_for_death_100_percent_value

    self.assurance_component = self.contribution_for_assurance_value * multiplier
    self.treatment_component = self.contribution_for_treatment_value
    self.ambulatory_component = self.contribution_for_ambulatory_value
    self.hospital_component = self.contribution_for_hospital_value
    self.infarct_component = self.contribution_for_infarct_value
    self.inability_component = self.contribution_for_inability_value
    self.sum_component =  self.assurance_component +
                          self.treatment_component +
                          self.ambulatory_component +
                          self.hospital_component +
                          self.infarct_component +
                          self.inability_component

    self.set_group_after_discounts
    self.set_group_after_increases  
    self.sum_after_monthly = self.sum_after_increases/12
  end

  def set_group_after_discounts
    self.sum_after_discounts = self.sum_component
    discounts.by_minus_value.each do |discount|
      self.sum_after_discounts =  self.sum_after_discounts + 
                                  self.sum_after_discounts*(discount.discount_increase/100)
    end    
  end
  def set_group_after_increases
    self.sum_after_increases = self.sum_after_discounts
    discounts.by_plus_value.each do |discount|
      self.sum_after_increases =  self.sum_after_increases + 
                                  self.sum_after_increases*(discount.discount_increase/100)
    end    
  end

  include ApplicationHelper
  def for_popover_data
    "Kowatcja: #{quotation_name} <br />
    System świadczeń: #{tariff_fixed_name} <br />
    Zakres: #{full_range_name} <br />
    Grupa ryzyka: #{risk_group} <br />
    SU: #{with_delimiter_and_separator(assurance)} <br />
    LE: #{with_delimiter_and_separator(treatment)} <br />
    AM: #{with_delimiter_and_separator(ambulatory)} <br />
    SZ: #{with_delimiter_and_separator(hospital)} <br />
    ZA: #{with_delimiter_and_separator(infarct)} <br />
    NZ: #{with_delimiter_and_separator(inability)} <br />
    Składka miesięczna: #{with_delimiter_and_separator(sum_after_monthly)} <br />
    Składka roczna: #{with_delimiter_and_separator(sum_after_year)}"
  end

  
end
