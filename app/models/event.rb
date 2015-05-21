class Event < ActiveRecord::Base
  validates :title, presence: true,
                    length: { in: 1..100 }

  validates :start_date, presence: true
  validates :end_date, presence: true

  belongs_to :user

  scope :by_user, ->(current_login_user_id) { where(user_id: current_login_user_id) }

end
