# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :rotation do
    rotation_date "2014-11-20"
    rotation_lock false
    date_file_send "2014-11-20"
    note "MyText"
    insurance nil
  end
end
