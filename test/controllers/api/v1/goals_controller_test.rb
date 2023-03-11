require "controllers/api/v1/test"

class Api::V1::GoalsControllerTest < Api::Test
  def setup
    # See `test/controllers/api/test.rb` for common set up for API tests.
    super

    @project = create(:project, team: @team)
    @goal = build(:goal, project: @project)
    @other_goals = create_list(:goal, 3)

    @another_goal = create(:goal, project: @project)

    # 🚅 super scaffolding will insert file-related logic above this line.
    @goal.save
    @another_goal.save
  end

  # This assertion is written in such a way that new attributes won't cause the tests to start failing, but removing
  # data we were previously providing to users _will_ break the test suite.
  def assert_proper_object_serialization(goal_data)
    # Fetch the goal in question and prepare to compare it's attributes.
    goal = Goal.find(goal_data["id"])

    assert_equal_or_nil goal_data['description'], goal.description
    # 🚅 super scaffolding will insert new fields above this line.

    assert_equal goal_data["project_id"], goal.project_id
  end

  test "index" do
    # Fetch and ensure nothing is seriously broken.
    get "/api/v1/projects/#{@project.id}/goals", params: {access_token: access_token}
    assert_response :success

    # Make sure it's returning our resources.
    goal_ids_returned = response.parsed_body.map { |goal| goal["id"] }
    assert_includes(goal_ids_returned, @goal.id)

    # But not returning other people's resources.
    assert_not_includes(goal_ids_returned, @other_goals[0].id)

    # And that the object structure is correct.
    assert_proper_object_serialization response.parsed_body.first
  end

  test "show" do
    # Fetch and ensure nothing is seriously broken.
    get "/api/v1/goals/#{@goal.id}", params: {access_token: access_token}
    assert_response :success

    # Ensure all the required data is returned properly.
    assert_proper_object_serialization response.parsed_body

    # Also ensure we can't do that same action as another user.
    get "/api/v1/goals/#{@goal.id}", params: {access_token: another_access_token}
    assert_response :not_found
  end

  test "create" do
    # Use the serializer to generate a payload, but strip some attributes out.
    params = {access_token: access_token}
    goal_data = JSON.parse(build(:goal, project: nil).to_api_json.to_json)
    goal_data.except!("id", "project_id", "created_at", "updated_at")
    params[:goal] = goal_data

    post "/api/v1/projects/#{@project.id}/goals", params: params
    assert_response :success

    # # Ensure all the required data is returned properly.
    assert_proper_object_serialization response.parsed_body

    # Also ensure we can't do that same action as another user.
    post "/api/v1/projects/#{@project.id}/goals",
      params: params.merge({access_token: another_access_token})
    assert_response :not_found
  end

  test "update" do
    # Post an attribute update ensure nothing is seriously broken.
    put "/api/v1/goals/#{@goal.id}", params: {
      access_token: access_token,
      goal: {
        description: 'Alternative String Value',
        # 🚅 super scaffolding will also insert new fields above this line.
      }
    }

    assert_response :success

    # Ensure all the required data is returned properly.
    assert_proper_object_serialization response.parsed_body

    # But we have to manually assert the value was properly updated.
    @goal.reload
    assert_equal @goal.description, 'Alternative String Value'
    # 🚅 super scaffolding will additionally insert new fields above this line.

    # Also ensure we can't do that same action as another user.
    put "/api/v1/goals/#{@goal.id}", params: {access_token: another_access_token}
    assert_response :not_found
  end

  test "destroy" do
    # Delete and ensure it actually went away.
    assert_difference("Goal.count", -1) do
      delete "/api/v1/goals/#{@goal.id}", params: {access_token: access_token}
      assert_response :success
    end

    # Also ensure we can't do that same action as another user.
    delete "/api/v1/goals/#{@another_goal.id}", params: {access_token: another_access_token}
    assert_response :not_found
  end
end
