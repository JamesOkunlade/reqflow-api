module Response
  def json_response(object, status = :ok, **options)
    render json: object, status: status, **options
  end
end
