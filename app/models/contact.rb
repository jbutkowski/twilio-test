# == Schema Information
#
# Table name: contacts
#
#  created_at :datetime         not null
#  email      :string
#  id         :integer          not null, primary key
#  mobile     :string
#  name       :string
#  subscribed :boolean
#  updated_at :datetime         not null
#

class Contact < ActiveRecord::Base

# Notify our appointment attendee X minutes before the appointment time
	def send_message(msg, image_url = nil)
		@twilio_number = ENV['TWILIO_NUMBER']
		@client = Twilio::REST::Client.new ENV['TWILIO_ACCOUNT_SID'], ENV['TWILIO_AUTH_TOKEN']
		message = @client.account.messages.create(
			:from => @twilio_number,
			:to => self.mobile,
			:body => msg,
			:media_url => image_url
		)
		puts message.to
	end

end
