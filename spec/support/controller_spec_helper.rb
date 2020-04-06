module ControllerSpecHelper
  # return valid headers
  def api_headers(api_client)
    {
      "Authorization" => "Token token=#{api_client.api_key}",
      "Content-Type" => "application/json",
    }
  end

  # return invalid headers
  def invalid_headers
    {
      "Authorization" => nil,
      "Content-Type" => "application/json",
    }
  end
end
