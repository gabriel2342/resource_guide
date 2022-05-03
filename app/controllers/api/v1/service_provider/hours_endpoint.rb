class Api::V1::ServiceProvider::HoursEndpoint < Api::V1::Root
  helpers do
    params :municipality_id do
      requires :municipality_id, type: Integer, allow_blank: false, desc: "Municipality ID"
    end

    params :id do
      requires :id, type: Integer, allow_blank: false, desc: "Hour ID"
    end

    params :hour do
      optional :name, type: String, desc: Api.heading(:name)
      # 🚅 super scaffolding will insert new fields above this line.
      # 🚅 super scaffolding will insert new arrays above this line.

      # 🚅 super scaffolding will insert processing for new fields above this line.
    end
  end

  resource "municipalities", desc: Api.title(:collection_actions) do
    after_validation do
      load_and_authorize_api_resource ServiceProvider::Hour
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
    get "/:municipality_id/service_provider/hours" do
      @paginated_hours = paginate @hours
      render @paginated_hours, serializer: Api.serializer
    end

    #
    # CREATE
    #

    desc Api.title(:create), &Api.create_desc
    params do
      use :municipality_id
      use :hour
    end
    route_setting :api_resource_options, permission: :create
    oauth2 "write"
    post "/:municipality_id/service_provider/hours" do
      if @hour.save
        render @hour, serializer: Api.serializer
      else
        record_not_saved @hour
      end
    end
  end

  resource "service_provider/hours", desc: Api.title(:member_actions) do
    after_validation do
      load_and_authorize_api_resource ServiceProvider::Hour
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
        render @hour, serializer: Api.serializer
      end
    end

    #
    # UPDATE
    #

    desc Api.title(:update), &Api.update_desc
    params do
      use :id
      use :hour
    end
    route_setting :api_resource_options, permission: :update
    oauth2 "write"
    route_param :id do
      put do
        if @hour.update(declared(params, include_missing: false))
          render @hour, serializer: Api.serializer
        else
          record_not_saved @hour
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
        render @hour.destroy, serializer: Api.serializer
      end
    end
  end
end
