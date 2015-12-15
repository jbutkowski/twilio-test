# == Schema Information
#
# Table name: subscribers
#
#  created_at   :datetime         not null
#  id           :integer          not null, primary key
#  phone_number :string
#  subscribed   :boolean
#  updated_at   :datetime         not null
#

class Subscriber < ActiveRecord::Base
end
