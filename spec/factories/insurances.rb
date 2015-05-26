# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :insurance do
    number "MyString"
    concluded "2014-11-15"
    valid_from "2014-11-15"
    applies_to "2014-11-15"
    pay "MyString"
    insurance_lock false
    note "MyText"
    company nil
  end
end
