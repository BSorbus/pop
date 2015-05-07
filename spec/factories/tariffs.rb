# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :tariff do
    category "MyString"
    description "MyString"
    quotation "MyString"
    tariff_fixed false
    full_range false
    risk_group "MyString"
    informal_group false
    condition_int 1
    condition_str "MyString"
    tariff_value "9.99"
  end
end
