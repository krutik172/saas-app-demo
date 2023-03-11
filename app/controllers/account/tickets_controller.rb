class Account::TicketsController < Account::ApplicationController
  account_load_and_authorize_resource :ticket, through: :project, through_association: :tickets

  # GET /account/projects/:project_id/tickets
  # GET /account/projects/:project_id/tickets.json
  def index
    delegate_json_to_api
  end

  # GET /account/tickets/:id
  # GET /account/tickets/:id.json
  def show
    delegate_json_to_api
  end

  # GET /account/projects/:project_id/tickets/new
  def new
  end

  # GET /account/tickets/:id/edit
  def edit
  end

  # POST /account/projects/:project_id/tickets
  # POST /account/projects/:project_id/tickets.json
  def create
    respond_to do |format|
      if @ticket.save
        format.html { redirect_to [:account, @ticket], notice: I18n.t("tickets.notifications.created") }
        format.json { render :show, status: :created, location: [:account, @ticket] }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @ticket.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /account/tickets/:id
  # PATCH/PUT /account/tickets/:id.json
  def update
    respond_to do |format|
      if @ticket.update(ticket_params)
        format.html { redirect_to [:account, @ticket], notice: I18n.t("tickets.notifications.updated") }
        format.json { render :show, status: :ok, location: [:account, @ticket] }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @ticket.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /account/tickets/:id
  # DELETE /account/tickets/:id.json
  def destroy
    @ticket.destroy
    respond_to do |format|
      format.html { redirect_to [:account, @project, :tickets], notice: I18n.t("tickets.notifications.destroyed") }
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

  def ticket_params
    params.require(:ticket).permit(:description,:status,:comments,:user_id)
  end
end
