# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :individual do
    first_name "MyString"
    last_name "MyString"
    address_city "MyString"
    address_street "MyString"
    address_house "MyString"
    address_number "MyString"
    address_postal_code "MyString"
    pesel "MyString"
    birth_date "2014-11-13"
    profession "MyString"
    note "MyText"
    user nil
  end
end
