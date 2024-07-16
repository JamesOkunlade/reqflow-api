class ApplicationController < ActionController::API
  include Pundit::Authorization
  include Response
  include ExceptionHandler

  # called before every action on controllers
  before_action :authorize_request
  attr_reader :current_user

  private

  # Check for valid request token and return user
  def authorize_request
    @current_user = (AuthorizeApiRequest.new(request.headers).call)[:user]
  end

  # Custom authorize method to use Pundit for authorization
  def authorize(record, query = nil)
    query ||= params[:action].to_s + "?"
    @_pundit_policy_authorized = true
    policy = policy(record)
    unless policy.public_send(query)
      raise Pundit::NotAuthorizedError, query: query, record: record, policy: policy
    end
  end

  rescue_from Pundit::NotAuthorizedError do |exception|
    json_response({ error: exception.message }, :forbidden)
  end
end
