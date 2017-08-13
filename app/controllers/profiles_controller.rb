class ProfilesController < ApplicationController
  before_action :authenticate_user!
  before_action :only_current_user
  # GET to /users/:user_id/profile/new
  def new
    # Render blank profile details form
    @profile = Profile.new
  end

  # POST to /users/:user_id/profile
  def create
    # Ensure that user exists
    @user = User.find(current_user.id)
    # Create profile linked to this specific user
    @profile = @user.build_profile(profile_params)
    if @profile.save
      flash[:success] = 'Profile updated!'
      redirect_to users_path(current_user.id)
    else
      render action: :new
    end
  end

  # GET to /users/:user_id/profile/edit
  def edit
    @user = User.find(current_user.id)
    @profile = @user.profile
  end

  # PATCH to /users/:user_id/profile
  def update
    # Retrieve the user from the database
    @user = User.find(current_user.id)
    # Retrieve that user's profile
    @profile = @user.profile
    # Mass assign edited profile attributes and save (update)
    if @profile.update_attributes(profile_params)
      flash[:success] = "Profile updated!"
      # Redirect user to their profile page
      redirect_to users_path(current_user.id)
    else
      render action: :edit
    end
  end

    private
  def profile_params
    params.require(:profile).permit(:first_name, :last_name, :job_title, :birth_date, :phone_number, :contact_email)
  end

  def only_current_user
    @user = User.find( current_user.id )
    redirect_to(root_url) unless @user == current_user
  end
end