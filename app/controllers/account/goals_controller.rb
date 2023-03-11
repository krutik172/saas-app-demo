class Account::GoalsController < Account::ApplicationController
  account_load_and_authorize_resource :goal, through: :project, through_association: :goals

  # GET /account/projects/:project_id/goals
  # GET /account/projects/:project_id/goals.json
  def index
    delegate_json_to_api
  end

  # GET /account/goals/:id
  # GET /account/goals/:id.json
  def show
    delegate_json_to_api
  end

  # GET /account/projects/:project_id/goals/new
  def new
  end

  # GET /account/goals/:id/edit
  def edit
  end

  # POST /account/projects/:project_id/goals
  # POST /account/projects/:project_id/goals.json
  def create
    respond_to do |format|
      if @goal.save
        format.html { redirect_to [:account, @goal], notice: I18n.t("goals.notifications.created") }
        format.json { render :show, status: :created, location: [:account, @goal] }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @goal.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /account/goals/:id
  # PATCH/PUT /account/goals/:id.json
  def update
    respond_to do |format|
      if @goal.update(goal_params)
        format.html { redirect_to [:account, @goal], notice: I18n.t("goals.notifications.updated") }
        format.json { render :show, status: :ok, location: [:account, @goal] }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @goal.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /account/goals/:id
  # DELETE /account/goals/:id.json
  def destroy
    @goal.destroy
    respond_to do |format|
      format.html { redirect_to [:account, @project, :goals], notice: I18n.t("goals.notifications.destroyed") }
      format.json { head :no_content }
    end
  end

  private

  if defined?(Api::V1::ApplicationController)
    include strong_parameters_from_api
  end

  def process_params(strong_params)
    # 🚅 super scaffolding will insert processing for new fields above this line.
  end
end
