require "test_helper"
require "controllers/api/test"

class Api::V1::ServiceProvidersEndpointTest < Api::Test
  include Devise::Test::IntegrationHelpers

    def setup
      # See `test/controllers/api/test.rb` for common set up for API tests.
      super

      @organization = create(:organization, team: @team)
@municipality = create(:municipality, organization: @organization)
@service_provider = create(:service_provider, municipality: @municipality)
      @other_service_providers = create_list(:service_provider, 3)
    end

    # This assertion is written in such a way that new attributes won't cause the tests to start failing, but removing
    # data we were previously providing to users _will_ break the test suite.
    def assert_proper_object_serialization(service_provider_data)
      # Fetch the service_provider in question and prepare to compare it's attributes.
      service_provider = ServiceProvider.find(service_provider_data["id"])

      assert_equal service_provider_data['name'], service_provider.name
      assert_equal service_provider_data['about'], service_provider.about
      assert_equal service_provider_data['street'], service_provider.street
      assert_equal service_provider_data['city'], service_provider.city
      assert_equal service_provider_data['state'], service_provider.state
      assert_equal service_provider_data['zip'], service_provider.zip
      assert_equal service_provider_data['contact_person'], service_provider.contact_person
      assert_equal service_provider_data['phone'], service_provider.phone
      assert_equal service_provider_data['email'], service_provider.email
      assert_equal service_provider_data['logo'], service_provider.logo
      assert_equal service_provider_data['url'], service_provider.url
      # 🚅 super scaffolding will insert new fields above this line.

      assert_equal service_provider_data["municipality_id"], service_provider.municipality_id
    end

    test "index" do
      # Fetch and ensure nothing is seriously broken.
      get "/api/v1/municipalities/#{@municipality.id}/service_providers", params: {access_token: access_token}
      assert_response :success

      # Make sure it's returning our resources.
      service_provider_ids_returned = response.parsed_body.dig("data").map { |service_provider| service_provider.dig("attributes", "id") }
      assert_includes(service_provider_ids_returned, @service_provider.id)

      # But not returning other people's resources.
      assert_not_includes(service_provider_ids_returned, @other_service_providers[0].id)

      # And that the object structure is correct.
      assert_proper_object_serialization response.parsed_body.dig("data").first.dig("attributes")
    end

    test "show" do
      # Fetch and ensure nothing is seriously broken.
      get "/api/v1/service_providers/#{@service_provider.id}", params: {access_token: access_token}
      assert_response :success

      # Ensure all the required data is returned properly.
      assert_proper_object_serialization response.parsed_body.dig("data", "attributes")

      # Also ensure we can't do that same action as another user.
      get "/api/v1/service_providers/#{@service_provider.id}", params: {access_token: another_access_token}
      assert_response_specific_not_found
    end

    test "create" do
      # Use the serializer to generate a payload, but strip some attributes out.
      service_provider_data = Api::V1::ServiceProviderSerializer.new(build(:service_provider, municipality: nil)).serializable_hash.dig(:data, :attributes)
      service_provider_data.except!(:id, :municipality_id, :created_at, :updated_at)

      post "/api/v1/municipalities/#{@municipality.id}/service_providers",
        params: service_provider_data.merge({access_token: access_token})

      assert_response :success

      # Ensure all the required data is returned properly.
      assert_proper_object_serialization response.parsed_body.dig("data", "attributes")

      # Also ensure we can't do that same action as another user.
      post "/api/v1/municipalities/#{@municipality.id}/service_providers",
        params: service_provider_data.merge({access_token: another_access_token})
      # TODO Why is this returning forbidden instead of the specific "Not Found" we get everywhere else?
      assert_response :forbidden
    end

    test "update" do
      # Post an attribute update ensure nothing is seriously broken.
      put "/api/v1/service_providers/#{@service_provider.id}", params: {
        access_token: access_token,
        name: 'Alternative String Value',
        about: 'Alternative String Value',
        street: 'Alternative String Value',
        city: 'Alternative String Value',
        state: 'Alternative String Value',
        zip: 'Alternative String Value',
        contact_person: 'Alternative String Value',
        phone: '+19053871234',
        email: 'another.email@test.com',
        url: 'Alternative String Value',
        # 🚅 super scaffolding will also insert new fields above this line.
      }

      assert_response :success

      # Ensure all the required data is returned properly.
      assert_proper_object_serialization response.parsed_body.dig("data", "attributes")

      # But we have to manually assert the value was properly updated.
      @service_provider.reload
      assert_equal @service_provider.name, 'Alternative String Value'
      assert_equal @service_provider.about, 'Alternative String Value'
      assert_equal @service_provider.street, 'Alternative String Value'
      assert_equal @service_provider.city, 'Alternative String Value'
      assert_equal @service_provider.state, 'Alternative String Value'
      assert_equal @service_provider.zip, 'Alternative String Value'
      assert_equal @service_provider.contact_person, 'Alternative String Value'
      assert_equal @service_provider.phone, '+19053871234'
      assert_equal @service_provider.email, 'another.email@test.com'
      assert_equal @service_provider.url, 'Alternative String Value'
      # 🚅 super scaffolding will additionally insert new fields above this line.

      # Also ensure we can't do that same action as another user.
      put "/api/v1/service_providers/#{@service_provider.id}", params: {access_token: another_access_token}
      assert_response_specific_not_found
    end

    test "destroy" do
      # Delete and ensure it actually went away.
      assert_difference("ServiceProvider.count", -1) do
        delete "/api/v1/service_providers/#{@service_provider.id}", params: {access_token: access_token}
        assert_response :success
      end

      # Also ensure we can't do that same action as another user.
      delete "/api/v1/service_providers/#{@service_provider.id}", params: {access_token: another_access_token}
      assert_response_specific_not_found
    end
end
