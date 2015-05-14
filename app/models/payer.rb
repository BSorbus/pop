class Payer < ActiveRecord::Base
  self.table_name = 'individuals'
 
  #has_many :coverages zmiana 14.05.2015
  has_many :coverages, foreign_key: :payer_id, class_name: "Coverage", dependent: :destroy 

  def fullname
    "#{last_name} #{first_name}, #{address_city}, #{pesel}"
  end

  def last_first_name
    "#{last_name} #{first_name}"
  end

  def street_house_number
    if address_number.blank?
      "#{address_street} #{address_house}"
    else
      "#{address_street} #{address_house}/#{address_number}"
    end
  end

  def postal_code_city
    "#{address_postal_code} #{address_city}"
  end
  
  
end
