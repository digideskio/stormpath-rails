class Stormpath::Rails::UsersController < Stormpath::Rails::BaseController
  def create
    @user = user_from_params

    if @user.save
      create_stormpath_account @user

      if Stormpath::Rails.config.verify_email
        render template: "users/verified"
      else
        initialize_session(@user)
        set_flash_message :notice, 'Your account was created successfully'
        redirect_to root_path
      end
    else
      render template: "users/new"
    end
  end

  def new
    @user = user_from_params
    render template: "users/new"
  end

  private

  def verified
    verify_email_token params[:sptoken]
    set_flash_message :notice, 'Your account has been verified and you are now able to log in.'
    render template: "sessions/new"
  end

  def user_from_params
    email = user_params.delete(:email)
    password = user_params.delete(:password)
    given_name = user_params.delete(:given_name)
    surname = user_params.delete(:surname)

    ::User.new.tap do |user|
      user.email = email
      user.password = password
      user.given_name = given_name
      user.surname = surname
    end
  end

  def user_params
    params[:user] || Hash.new
  end
end