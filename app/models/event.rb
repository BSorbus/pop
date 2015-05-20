class Event < ActiveRecord::Base

  belongs_to :user

  scope :by_user, ->(current_login_user_id) { where(user_id: current_login_user_id) }

end
