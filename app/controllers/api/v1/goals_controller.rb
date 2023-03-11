# Api::V1::ApplicationController is in the starter repository and isn't
# needed for this package's unit tests, but our CI tests will try to load this
# class because eager loading is set to `true` when CI=true.
# We wrap this class in an `if` statement to circumvent this issue.
if defined?(Api::V1::ApplicationController)
  class Api::V1::GoalsController < Api::V1::ApplicationController
    account_load_and_authorize_resource :goal, through: :project, through_association: :goals

    # GET /api/v1/projects/:project_id/goals
    def index
    end

    # GET /api/v1/goals/:id
    def show
    end

    # POST /api/v1/projects/:project_id/goals
    def create
      if @goal.save
        render :show, status: :created, location: [:api, :v1, @goal]
      else
        render json: @goal.errors, status: :unprocessable_entity
      end
    end

    # PATCH/PUT /api/v1/goals/:id
    def update
      if @goal.update(goal_params)
        render :show
      else
        render json: @goal.errors, status: :unprocessable_entity
      end
    end

    # DELETE /api/v1/goals/:id
    def destroy
      @goal.destroy
    end

    private

    module StrongParameters
      # Only allow a list of trusted parameters through.
      def goal_params
        strong_params = params.require(:goal).permit(
          *permitted_fields,
          :description,
          # 🚅 super scaffolding will insert new fields above this line.
          *permitted_arrays,
          # 🚅 super scaffolding will insert new arrays above this line.
        )

        process_params(strong_params)

        strong_params
      end
    end

    include StrongParameters
  end
else
  class Api::V1::GoalsController
  end
end
