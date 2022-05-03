class Api::V1::MunicipalitiesEndpoint < Api::V1::Root
  helpers do
    params :organization_id do
      requires :organization_id, type: Integer, allow_blank: false, desc: "Organization ID"
    end

    params :id do
      requires :id, type: Integer, allow_blank: false, desc: "Municipality ID"
    end

    params :municipality do
      optional :name, type: String, desc: Api.heading(:name)
      optional :url, type: String, desc: Api.heading(:url)
      # 🚅 super scaffolding will insert new fields above this line.
      # 🚅 super scaffolding will insert new arrays above this line.

      # 🚅 super scaffolding will insert processing for new fields above this line.
    end
  end

  resource "organizations", desc: Api.title(:collection_actions) do
    after_validation do
      load_and_authorize_api_resource Municipality
    end

    #
    # INDEX
    #

    desc Api.title(:index), &Api.index_desc
    params do
      use :organization_id
    end
    oauth2
    paginate per_page: 100
    get "/:organization_id/municipalities" do
      @paginated_municipalities = paginate @municipalities
      render @paginated_municipalities, serializer: Api.serializer
    end

    #
    # CREATE
    #

    desc Api.title(:create), &Api.create_desc
    params do
      use :organization_id
      use :municipality
    end
    route_setting :api_resource_options, permission: :create
    oauth2 "write"
    post "/:organization_id/municipalities" do
      if @municipality.save
        render @municipality, serializer: Api.serializer
      else
        record_not_saved @municipality
      end
    end
  end

  resource "municipalities", desc: Api.title(:member_actions) do
    after_validation do
      load_and_authorize_api_resource Municipality
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
        render @municipality, serializer: Api.serializer
      end
    end

    #
    # UPDATE
    #

    desc Api.title(:update), &Api.update_desc
    params do
      use :id
      use :municipality
    end
    route_setting :api_resource_options, permission: :update
    oauth2 "write"
    route_param :id do
      put do
        if @municipality.update(declared(params, include_missing: false))
          render @municipality, serializer: Api.serializer
        else
          record_not_saved @municipality
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
        render @municipality.destroy, serializer: Api.serializer
      end
    end
  end
end
