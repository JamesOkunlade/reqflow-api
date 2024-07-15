class UsersController < ApplicationController
  skip_before_action :authorize_request, only: :create

  # POST /signup
  # return authenticated token upon signup
  def create
    user = User.create!(user_params)
    response = AuthenticateUser.new(user.email, user.password).call

    json_response(response, :created)
  end

  private

  def user_params
    # params.permit(
    params.require(:user).permit(
      :first_name,
      :last_name,
      :email,
      :password,
      :password_confirmation
    )
  end
end

