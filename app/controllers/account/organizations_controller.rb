class Account::OrganizationsController < Account::ApplicationController
  account_load_and_authorize_resource :organization, through: :team, through_association: :organizations

  # GET /account/teams/:team_id/organizations
  # GET /account/teams/:team_id/organizations.json
  def index
    # if you only want these objects shown on their parent's show page, uncomment this:
    # redirect_to [:account, @team]
  end

  # GET /account/organizations/:id
  # GET /account/organizations/:id.json
  def show
  end

  # GET /account/teams/:team_id/organizations/new
  def new
  end

  # GET /account/organizations/:id/edit
  def edit
  end

  # POST /account/teams/:team_id/organizations
  # POST /account/teams/:team_id/organizations.json
  def create
    respond_to do |format|
      if @organization.save
        format.html { redirect_to [:account, @team, :organizations], notice: I18n.t("organizations.notifications.created") }
        format.json { render :show, status: :created, location: [:account, @organization] }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @organization.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /account/organizations/:id
  # PATCH/PUT /account/organizations/:id.json
  def update
    respond_to do |format|
      if @organization.update(organization_params)
        format.html { redirect_to [:account, @organization], notice: I18n.t("organizations.notifications.updated") }
        format.json { render :show, status: :ok, location: [:account, @organization] }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @organization.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /account/organizations/:id
  # DELETE /account/organizations/:id.json
  def destroy
    @organization.destroy
    respond_to do |format|
      format.html { redirect_to [:account, @team, :organizations], notice: I18n.t("organizations.notifications.destroyed") }
      format.json { head :no_content }
    end
  end

  private

  # Never trust parameters from the scary internet, only allow the white list through.
  def organization_params
    strong_params = params.require(:organization).permit(
      :name,
      # 🚅 super scaffolding will insert new fields above this line.
      # 🚅 super scaffolding will insert new arrays above this line.
    )

    # 🚅 super scaffolding will insert processing for new fields above this line.

    strong_params
  end
end
