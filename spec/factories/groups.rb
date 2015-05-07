# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :group do
    number 1
    quotation "MyString"
    tariff_fixed false
    full_range false
    risk_group "MyString"
    assurance "9.99"
    assurance_component "9.99"
    treatment "9.99"
    treatment_component "9.99"
    ambulatory "9.99"
    ambulatory_component "9.99"
    hospital "9.99"
    hospital_component "9.99"
    infarct "9.99"
    infarct_component "9.99"
    inability "9.99"
    inability_component "9.99"
    death_100_percent false
    sum_component "9.99"
    sum_after_discounts "9.99"
    sum_after_increases "9.99"
    sum_after_monthly "9.99"
    insurance nil
  end
end
