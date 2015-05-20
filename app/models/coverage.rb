class Coverage < ActiveRecord::Base

  validates :rotation_id,  presence: true
  validates :group_id,  presence: true
  validates :insured_id,  presence: true,  
                          :uniqueness => { :scope => [:rotation_id], :message => "już występuje w tej Rotacji" }  
  validates :payer_id,  presence: true

  belongs_to :rotation
  belongs_to :group
  belongs_to :insured
  belongs_to :payer

  scope :by_rotation, ->(only_for_rotation_id) { where(rotation_id: only_for_rotation_id) }
  scope :by_group, ->(only_for_group_id) { where(group_id: only_for_group_id) }
  scope :by_insured, ->(only_for_insured_id) { where(insured_id: only_for_insured_id) }
  scope :by_payer, ->(only_for_payer_id) { where(payer_id: only_for_payer_id) }

  # po zaladowaniu odkomentuj to !!!!!!!!!!!!!!!!!!
  #before_save :coverage_in_locked_rotation
  #before_destroy :coverage_in_locked_rotation, prepend: true

  def coverage_in_locked_rotation
    if rotation.rotation_lock? 
      errors[:base] << "Nie można usunąć Ochrony, która jest użyta w zablokowanej Rotacji"
      false
    end
  end

  def fullname
    "Ochrona w rotacji: #{rotation.rotation_date}, dla: #{insured.fullname}, #{group.fullname}"
  end

  def self.to_csv_as_nu
    CSV.generate(headers: false, col_sep: '|') do |csv|

      all.each do |coverage|
        csv << [coverage.insured.pesel, 
                coverage.insured.first_name, 
                coverage.insured.last_name, 
                coverage.insured.birth_date.strftime("%d.%m.%Y"), 
                coverage.insured.street_house_number, 
                coverage.insured.address_postal_code, 
                coverage.insured.address_city, 
                coverage.group.number, 
                coverage.rotation.insurance.number.last(8), 
                coverage.rotation.rotation_date.strftime("%d.%m.%Y"), 
                "*"]
      end
    end     
  end

  def self.to_csv_add_remove(coverages_add, coverages_remove, date_end_coverage)
    #zmien date wyłączenia "-" jako następna rotacja minus 1 dzień
    CSV.generate(headers: false, col_sep: '|') do |csv|

      coverages_add.each do |coverage|
        csv << [coverage.insured.pesel, 
                coverage.insured.first_name, 
                coverage.insured.last_name, 
                coverage.insured.birth_date.strftime("%d.%m.%Y"), 
                coverage.insured.street_house_number, 
                coverage.insured.address_postal_code, 
                coverage.insured.address_city, 
                coverage.group.number, 
                coverage.rotation.insurance.number.last(8), 
                coverage.rotation.rotation_date.strftime("%d.%m.%Y"), 
                "+"]
      end

      coverages_remove.each do |coverage|
        csv << [coverage.insured.pesel, 
                coverage.insured.first_name, 
                coverage.insured.last_name, 
                coverage.insured.birth_date.strftime("%d.%m.%Y"), 
                coverage.insured.street_house_number, 
                coverage.insured.address_postal_code, 
                coverage.insured.address_city, 
                coverage.group.number, 
                coverage.rotation.insurance.number.last(8), 
                date_end_coverage.strftime("%d.%m.%Y"), 
                "-"]
      end
    end     

  end

  def self.to_csv
    # działa !
    #attributes = %w{id rotation_id group_id insured_id payer_id }
    #CSV.generate(headers: true) do |csv|
    #  csv << attributes
    #
    #  all.each do |p|
    #    csv << attributes.map{ |attr| p.send(attr) }
    #  end
    #end     

    CSV.generate(headers: false, col_sep: '|') do |csv|
      #columns_header = %w{pesel first_name last_name birth_date id rotation_id group_id insured_id payer_id }
      #csv << columns_header

      all.each do |coverage|
        csv << [coverage.insured.pesel, 
                coverage.insured.first_name, 
                coverage.insured.last_name, 
                coverage.insured.birth_date.strftime("%d.%m.%Y"), 
                coverage.insured.street_house_number, 
                coverage.insured.address_postal_code, 
                coverage.insured.address_city, 
                coverage.group.number, 
                coverage.rotation.insurance.number.last(8), 
                coverage.rotation.rotation_date.strftime("%d.%m.%Y"), 
                "+"]
      end
    end
     
  end

end
