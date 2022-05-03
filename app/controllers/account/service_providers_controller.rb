class Account::ServiceProvidersController < Account::ApplicationController
  account_load_and_authorize_resource :service_provider, through: :municipality, through_association: :service_providers

  # GET /account/municipalities/:municipality_id/service_providers
  # GET /account/municipalities/:municipality_id/service_providers.json
  def index
    # if you only want these objects shown on their parent's show page, uncomment this:
    # redirect_to [:account, @municipality]
  end

  # GET /account/service_providers/:id
  # GET /account/service_providers/:id.json
  def show
  end

  # GET /account/municipalities/:municipality_id/service_providers/new
  def new
  end

  # GET /account/service_providers/:id/edit
  def edit
  end

  # POST /account/municipalities/:municipality_id/service_providers
  # POST /account/municipalities/:municipality_id/service_providers.json
  def create
    respond_to do |format|
      if @service_provider.save
        format.html { redirect_to [:account, @municipality, :service_providers], notice: I18n.t("service_providers.notifications.created") }
        format.json { render :show, status: :created, location: [:account, @service_provider] }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @service_provider.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /account/service_providers/:id
  # PATCH/PUT /account/service_providers/:id.json
  def update
    respond_to do |format|
      if @service_provider.update(service_provider_params)
        format.html { redirect_to [:account, @service_provider], notice: I18n.t("service_providers.notifications.updated") }
        format.json { render :show, status: :ok, location: [:account, @service_provider] }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @service_provider.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /account/service_providers/:id
  # DELETE /account/service_providers/:id.json
  def destroy
    @service_provider.destroy
    respond_to do |format|
      format.html { redirect_to [:account, @municipality, :service_providers], notice: I18n.t("service_providers.notifications.destroyed") }
      format.json { head :no_content }
    end
  end

  private

  # Never trust parameters from the scary internet, only allow the white list through.
  def service_provider_params
    strong_params = params.require(:service_provider).permit(
      :name,
      :about,
      :street,
      :city,
      :state,
      :zip,
      :contact_person,
      :phone,
      :email,
      :logo,
      :url,
      # 🚅 super scaffolding will insert new fields above this line.
      # 🚅 super scaffolding will insert new arrays above this line.
    )

    # 🚅 super scaffolding will insert processing for new fields above this line.

    strong_params
  end
end
