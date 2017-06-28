class ContactsController < ApplicationController
  # GET request to /contact-us
  # Show new contact form
  def new
    @contact = Contact.new
  end

  # POST request /contacts
  def create
    # Mass assignment of form fields to contact object
    @contact = Contact.new(contact_params)
    # Save contact object to database
    if @contact.save
      # Store parameters into variables
      name = params[:contact][:name]
      email = params[:contact][:email]
      body = params[:contact][:comments]
      # Plug variables to Contact Mailer method and send email
      ContactMailer.contact_email(name, email, body).deliver
      # Store success message in flash hash and redirect to new action
      flash[:success] = 'Message sent.'
    else
      # If contact object doesn't save, store errors in flash hash and redirect
      # to new action anyways
      flash[:danger] = @contact.errors.full_messages.join(', ')
    end
    redirect_to new_contact_path
  end

  private
  # To collect data from form, use strong parameters and whitelist form fields
  def contact_params
    params.require(:contact).permit(:name, :email, :comments)
  end
end