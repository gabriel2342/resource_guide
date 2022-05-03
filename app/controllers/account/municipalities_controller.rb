class Account::MunicipalitiesController < Account::ApplicationController
  account_load_and_authorize_resource :municipality, through: :organization, through_association: :municipalities

  # GET /account/organizations/:organization_id/municipalities
  # GET /account/organizations/:organization_id/municipalities.json
  def index
    # if you only want these objects shown on their parent's show page, uncomment this:
    # redirect_to [:account, @organization]
  end

  # GET /account/municipalities/:id
  # GET /account/municipalities/:id.json
  def show
  end

  # GET /account/organizations/:organization_id/municipalities/new
  def new
  end

  # GET /account/municipalities/:id/edit
  def edit
  end

  # POST /account/organizations/:organization_id/municipalities
  # POST /account/organizations/:organization_id/municipalities.json
  def create
    respond_to do |format|
      if @municipality.save
        format.html { redirect_to [:account, @organization, :municipalities], notice: I18n.t("municipalities.notifications.created") }
        format.json { render :show, status: :created, location: [:account, @municipality] }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @municipality.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /account/municipalities/:id
  # PATCH/PUT /account/municipalities/:id.json
  def update
    respond_to do |format|
      if @municipality.update(municipality_params)
        format.html { redirect_to [:account, @municipality], notice: I18n.t("municipalities.notifications.updated") }
        format.json { render :show, status: :ok, location: [:account, @municipality] }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @municipality.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /account/municipalities/:id
  # DELETE /account/municipalities/:id.json
  def destroy
    @municipality.destroy
    respond_to do |format|
      format.html { redirect_to [:account, @organization, :municipalities], notice: I18n.t("municipalities.notifications.destroyed") }
      format.json { head :no_content }
    end
  end

  private

  # Never trust parameters from the scary internet, only allow the white list through.
  def municipality_params
    strong_params = params.require(:municipality).permit(
      :name,
      :url,
      # 🚅 super scaffolding will insert new fields above this line.
      # 🚅 super scaffolding will insert new arrays above this line.
    )

    # 🚅 super scaffolding will insert processing for new fields above this line.

    strong_params
  end
end
