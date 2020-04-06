require 'rails_helper'

RSpec.describe('GitCloud Webhook', type: :request) do
  let(:api_client) { create(:api_client) }

  let(:no_token_headers) { invalid_headers }
  let(:token_headers) { api_headers(api_client) }
  let(:expired_token_headers) { api_headers(expired_api_client) }

  let(:invalid_payload) { load_json_from_fixture("spec/fixtures/services/commit_parser_payload.json") }

  describe "POST /git" do
    context "when invalid request" do
      it 'should result in forbidden due to no token' do
        post '/webhooks/git/', params: invalid_payload.to_json, headers: no_token_headers
        expect(response).to(have_http_status(403))
        response_body = JSON.parse(response.body)
        expect(response_body["error_message"]).to(eq("Please provide Auth Headers!"))
      end

      it 'should result in forbidden due to expired token' do
        expired_api_client = create(:api_client_with_expired_key)

        # need help to figure this out
        # post '/webhooks/git/', params: invalid_payload.to_json, headers: api_headers(expired_api_client)

        expired_api_client.expiry = Faker::Date.between(from: 20.days.ago, to: 1.days.ago)
        expired_api_client.save

        expired_headers = {
          "Authorization" => "Token token=#{expired_api_client.api_key}",
          "Content-Type" => "application/json",
        }

        post '/webhooks/git/', params: invalid_payload.to_json, headers: expired_headers
        expect(response).to(have_http_status(401))
        response_body = JSON.parse(response.body)
        expect(response_body["error_message"]).to(eq("API Key Expired!"))
      end

      it "should raise 403 for absent token" do
        expired_headers = {
          "Authorization" => "Token token=no-token",
          "Content-Type" => "application/json",
        }

        post '/webhooks/git/', params: invalid_payload.to_json, headers: expired_headers
        expect(response).to(have_http_status(403))
        response_body = JSON.parse(response.body)
        expect(response_body["error_message"]).to(eq("Please provide a valid token!"))
      end

      it "should raise 400 for bad payload" do
        post '/webhooks/git/', params: invalid_payload.to_json, headers: token_headers
        expect(response).to(have_http_status(400))
        response_body = JSON.parse(response.body)
        expect(response_body["error_message"].first).to(eq("Invalid Event type!"))
      end
    end
  end
end
