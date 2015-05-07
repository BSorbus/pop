# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :company do
    short "MyString"
    name "MyString"
    address_city "MyString"
    address_street "MyString"
    address_house "MyString"
    address_number "MyString"
    address_postal_code "MyString"
    phone "MyString"
    email "MyString"
    nip "MyString"
    regon "MyString"
    pesel "MyString"
    note "MyText"
    user nil
  end
end
