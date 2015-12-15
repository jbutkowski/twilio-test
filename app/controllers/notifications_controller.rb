class NotificationsController < ApplicationController

  # Receive incoming SMS
  def incoming
    # Grab the phone number from incoming Twilio params
    @phone_number = params[:From]

    # Find the contact associated with this number or create a new one
    @new_contact = Contact.exists?(:phone_number => @phone_number) === false
    @contact = Contact.first_or_create(:phone_number => @phone_number)

    @body = if params[:Body].nil? then '' else params[:Body].downcase end
    begin
      if @new_contact
        output = "Thanks for contacting LMIT! Text 'subscribe' if you would to receive updates via text message."
      else
        # Process the command from our Contact
        output = process_message(@body, @contact)
      end
    rescue
      output = "Something went wrong. Try again."
    end

    # Render the TwiML response
    respond(output)
  end

  # Create a new notification
  def new
    message = params[:message]
    image_url = params[:image_url]

    Contact.all.each do |s|
      begin
        s.send_message(message, image_url)
        flash[:success] = "Messages on their way!"
      rescue 
        flash[:alert] = "Something when wrong."
      end
    end
    redirect_to '/'
  end

  def index
  end

  private
    # Use callbacks to share common setup or constraints between actions.

    # Process incoming SMS
    def process_message(message, contact)
      if message == 'subscribe' || message == 'unsubscribe'
        # If the user has subscribed flip the bit
        # and let them know
        subscribed = message === 'subscribe'
        contact.update :subscribed => subscribed

        # Respond appropriately
        output = "You are now subscribed for updates."
        if !contact.subscribed
          output = "You have unsubscribed from notifications. Test 'subscribe' to start receieving updates again"
        end
      else
        # If we don't recognize the command, text back with the list of
        # available commands
        output = "Sorry, we don't recognize that command. Available commands are: 'subscribe' or 'unsubscribe'."
      end
      return output
    end

    # Send an SMS back to the Contact
    def respond(message)
      response = Twilio::TwiML::Response.new do |r|
        r.Message message
      end
      render text: response.text
    end

end