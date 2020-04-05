module Rack
  class Attack
    # `Rack::Attack` is configured to use the `Rails.cache` value by default

    # Allow all local traffic
    # whitelist('allow-localhost') do |req|
    #   '127.0.0.1' == req.ip || '::1' == req.ip
    # end

    # Allow an IP address to make DAILY_IP_REQUEST_QUOTA requests every 1 day
    throttle('req/ip', limit: ENV["DAILY_IP_REQUEST_QUOTA"].to_i, period: 1.day, &:ip)

    # Send the following response to throttled clients
    self.throttled_response = ->(env) {
      retry_after = (env['rack.attack.match_data'] || {})[:period]
      [
        429,
        { 'Content-Type' => 'application/json', 'Retry-After' => retry_after.to_s },
        [{ error_message: "Throttle limit reached. Retry later." }.to_json],
      ]
    }
  end
end
