require "test_helper"
require "controllers/api/test"

class Api::V1::ServiceProvider::HoursEndpointTest < Api::Test
  include Devise::Test::IntegrationHelpers

    def setup
      # See `test/controllers/api/test.rb` for common set up for API tests.
      super

      @municipality = create(:municipality, team: @team)
@hour = create(:service_provider_hour, municipality: @municipality)
      @other_hours = create_list(:service_provider_hour, 3)
    end

    # This assertion is written in such a way that new attributes won't cause the tests to start failing, but removing
    # data we were previously providing to users _will_ break the test suite.
    def assert_proper_object_serialization(hour_data)
      # Fetch the hour in question and prepare to compare it's attributes.
      hour = ServiceProvider::Hour.find(hour_data["id"])

      assert_equal hour_data['name'], hour.name
      # 🚅 super scaffolding will insert new fields above this line.

      assert_equal hour_data["municipality_id"], hour.municipality_id
    end

    test "index" do
      # Fetch and ensure nothing is seriously broken.
      get "/api/v1/municipalities/#{@municipality.id}/service_provider/hours", params: {access_token: access_token}
      assert_response :success

      # Make sure it's returning our resources.
      hour_ids_returned = response.parsed_body.dig("data").map { |hour| hour.dig("attributes", "id") }
      assert_includes(hour_ids_returned, @hour.id)

      # But not returning other people's resources.
      assert_not_includes(hour_ids_returned, @other_hours[0].id)

      # And that the object structure is correct.
      assert_proper_object_serialization response.parsed_body.dig("data").first.dig("attributes")
    end

    test "show" do
      # Fetch and ensure nothing is seriously broken.
      get "/api/v1/service_provider/hours/#{@hour.id}", params: {access_token: access_token}
      assert_response :success

      # Ensure all the required data is returned properly.
      assert_proper_object_serialization response.parsed_body.dig("data", "attributes")

      # Also ensure we can't do that same action as another user.
      get "/api/v1/service_provider/hours/#{@hour.id}", params: {access_token: another_access_token}
      assert_response_specific_not_found
    end

    test "create" do
      # Use the serializer to generate a payload, but strip some attributes out.
      hour_data = Api::V1::ServiceProvider::HourSerializer.new(build(:service_provider_hour, municipality: nil)).serializable_hash.dig(:data, :attributes)
      hour_data.except!(:id, :municipality_id, :created_at, :updated_at)

      post "/api/v1/municipalities/#{@municipality.id}/service_provider/hours",
        params: hour_data.merge({access_token: access_token})

      assert_response :success

      # Ensure all the required data is returned properly.
      assert_proper_object_serialization response.parsed_body.dig("data", "attributes")

      # Also ensure we can't do that same action as another user.
      post "/api/v1/municipalities/#{@municipality.id}/service_provider/hours",
        params: hour_data.merge({access_token: another_access_token})
      # TODO Why is this returning forbidden instead of the specific "Not Found" we get everywhere else?
      assert_response :forbidden
    end

    test "update" do
      # Post an attribute update ensure nothing is seriously broken.
      put "/api/v1/service_provider/hours/#{@hour.id}", params: {
        access_token: access_token,
        name: 'Alternative String Value',
        # 🚅 super scaffolding will also insert new fields above this line.
      }

      assert_response :success

      # Ensure all the required data is returned properly.
      assert_proper_object_serialization response.parsed_body.dig("data", "attributes")

      # But we have to manually assert the value was properly updated.
      @hour.reload
      assert_equal @hour.name, 'Alternative String Value'
      # 🚅 super scaffolding will additionally insert new fields above this line.

      # Also ensure we can't do that same action as another user.
      put "/api/v1/service_provider/hours/#{@hour.id}", params: {access_token: another_access_token}
      assert_response_specific_not_found
    end

    test "destroy" do
      # Delete and ensure it actually went away.
      assert_difference("ServiceProvider::Hour.count", -1) do
        delete "/api/v1/service_provider/hours/#{@hour.id}", params: {access_token: access_token}
        assert_response :success
      end

      # Also ensure we can't do that same action as another user.
      delete "/api/v1/service_provider/hours/#{@hour.id}", params: {access_token: another_access_token}
      assert_response_specific_not_found
    end
end
