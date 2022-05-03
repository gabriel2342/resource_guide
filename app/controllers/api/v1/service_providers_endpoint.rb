class Api::V1::ServiceProvidersEndpoint < Api::V1::Root
  helpers do
    params :municipality_id do
      requires :municipality_id, type: Integer, allow_blank: false, desc: "Municipality ID"
    end

    params :id do
      requires :id, type: Integer, allow_blank: false, desc: "Service Provider ID"
    end

    params :service_provider do
      optional :name, type: String, desc: Api.heading(:name)
      optional :about, type: String, desc: Api.heading(:about)
      optional :street, type: String, desc: Api.heading(:street)
      optional :city, type: String, desc: Api.heading(:city)
      optional :state, type: String, desc: Api.heading(:state)
      optional :zip, type: String, desc: Api.heading(:zip)
      optional :contact_person, type: String, desc: Api.heading(:contact_person)
      optional :phone, type: String, desc: Api.heading(:phone)
      optional :email, type: String, desc: Api.heading(:email)
      optional :logo, type: String, desc: Api.heading(:logo)
      optional :url, type: String, desc: Api.heading(:url)
      # 🚅 super scaffolding will insert new fields above this line.
      # 🚅 super scaffolding will insert new arrays above this line.

      # 🚅 super scaffolding will insert processing for new fields above this line.
    end
  end

  resource "municipalities", desc: Api.title(:collection_actions) do
    after_validation do
      load_and_authorize_api_resource ServiceProvider
    end

    #
    # INDEX
    #

    desc Api.title(:index), &Api.index_desc
    params do
      use :municipality_id
    end
    oauth2
    paginate per_page: 100
    get "/:municipality_id/service_providers" do
      @paginated_service_providers = paginate @service_providers
      render @paginated_service_providers, serializer: Api.serializer
    end

    #
    # CREATE
    #

    desc Api.title(:create), &Api.create_desc
    params do
      use :municipality_id
      use :service_provider
    end
    route_setting :api_resource_options, permission: :create
    oauth2 "write"
    post "/:municipality_id/service_providers" do
      if @service_provider.save
        render @service_provider, serializer: Api.serializer
      else
        record_not_saved @service_provider
      end
    end
  end

  resource "service_providers", desc: Api.title(:member_actions) do
    after_validation do
      load_and_authorize_api_resource ServiceProvider
    end

    #
    # SHOW
    #

    desc Api.title(:show), &Api.show_desc
    params do
      use :id
    end
    oauth2
    route_param :id do
      get do
        render @service_provider, serializer: Api.serializer
      end
    end

    #
    # UPDATE
    #

    desc Api.title(:update), &Api.update_desc
    params do
      use :id
      use :service_provider
    end
    route_setting :api_resource_options, permission: :update
    oauth2 "write"
    route_param :id do
      put do
        if @service_provider.update(declared(params, include_missing: false))
          render @service_provider, serializer: Api.serializer
        else
          record_not_saved @service_provider
        end
      end
    end

    #
    # DESTROY
    #

    desc Api.title(:destroy), &Api.destroy_desc
    params do
      use :id
    end
    route_setting :api_resource_options, permission: :destroy
    oauth2 "delete"
    route_param :id do
      delete do
        render @service_provider.destroy, serializer: Api.serializer
      end
    end
  end
end
