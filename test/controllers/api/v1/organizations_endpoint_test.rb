require "test_helper"
require "controllers/api/test"

class Api::V1::OrganizationsEndpointTest < Api::Test
  include Devise::Test::IntegrationHelpers

    def setup
      # See `test/controllers/api/test.rb` for common set up for API tests.
      super

      @organization = create(:organization, team: @team)
      @other_organizations = create_list(:organization, 3)
    end

    # This assertion is written in such a way that new attributes won't cause the tests to start failing, but removing
    # data we were previously providing to users _will_ break the test suite.
    def assert_proper_object_serialization(organization_data)
      # Fetch the organization in question and prepare to compare it's attributes.
      organization = Organization.find(organization_data["id"])

      assert_equal organization_data['name'], organization.name
      # 🚅 super scaffolding will insert new fields above this line.

      assert_equal organization_data["team_id"], organization.team_id
    end

    test "index" do
      # Fetch and ensure nothing is seriously broken.
      get "/api/v1/teams/#{@team.id}/organizations", params: {access_token: access_token}
      assert_response :success

      # Make sure it's returning our resources.
      organization_ids_returned = response.parsed_body.dig("data").map { |organization| organization.dig("attributes", "id") }
      assert_includes(organization_ids_returned, @organization.id)

      # But not returning other people's resources.
      assert_not_includes(organization_ids_returned, @other_organizations[0].id)

      # And that the object structure is correct.
      assert_proper_object_serialization response.parsed_body.dig("data").first.dig("attributes")
    end

    test "show" do
      # Fetch and ensure nothing is seriously broken.
      get "/api/v1/organizations/#{@organization.id}", params: {access_token: access_token}
      assert_response :success

      # Ensure all the required data is returned properly.
      assert_proper_object_serialization response.parsed_body.dig("data", "attributes")

      # Also ensure we can't do that same action as another user.
      get "/api/v1/organizations/#{@organization.id}", params: {access_token: another_access_token}
      assert_response_specific_not_found
    end

    test "create" do
      # Use the serializer to generate a payload, but strip some attributes out.
      organization_data = Api::V1::OrganizationSerializer.new(build(:organization, team: nil)).serializable_hash.dig(:data, :attributes)
      organization_data.except!(:id, :team_id, :created_at, :updated_at)

      post "/api/v1/teams/#{@team.id}/organizations",
        params: organization_data.merge({access_token: access_token})

      assert_response :success

      # Ensure all the required data is returned properly.
      assert_proper_object_serialization response.parsed_body.dig("data", "attributes")

      # Also ensure we can't do that same action as another user.
      post "/api/v1/teams/#{@team.id}/organizations",
        params: organization_data.merge({access_token: another_access_token})
      # TODO Why is this returning forbidden instead of the specific "Not Found" we get everywhere else?
      assert_response :forbidden
    end

    test "update" do
      # Post an attribute update ensure nothing is seriously broken.
      put "/api/v1/organizations/#{@organization.id}", params: {
        access_token: access_token,
        name: 'Alternative String Value',
        # 🚅 super scaffolding will also insert new fields above this line.
      }

      assert_response :success

      # Ensure all the required data is returned properly.
      assert_proper_object_serialization response.parsed_body.dig("data", "attributes")

      # But we have to manually assert the value was properly updated.
      @organization.reload
      assert_equal @organization.name, 'Alternative String Value'
      # 🚅 super scaffolding will additionally insert new fields above this line.

      # Also ensure we can't do that same action as another user.
      put "/api/v1/organizations/#{@organization.id}", params: {access_token: another_access_token}
      assert_response_specific_not_found
    end

    test "destroy" do
      # Delete and ensure it actually went away.
      assert_difference("Organization.count", -1) do
        delete "/api/v1/organizations/#{@organization.id}", params: {access_token: access_token}
        assert_response :success
      end

      # Also ensure we can't do that same action as another user.
      delete "/api/v1/organizations/#{@organization.id}", params: {access_token: another_access_token}
      assert_response_specific_not_found
    end
end
