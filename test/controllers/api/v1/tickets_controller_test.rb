require "controllers/api/v1/test"

class Api::V1::TicketsControllerTest < Api::Test
  def setup
    # See `test/controllers/api/test.rb` for common set up for API tests.
    super

    @project = create(:project, team: @team)
    @ticket = build(:ticket, project: @project)
    @other_tickets = create_list(:ticket, 3)

    @another_ticket = create(:ticket, project: @project)

    # 🚅 super scaffolding will insert file-related logic above this line.
    @ticket.save
    @another_ticket.save
  end

  # This assertion is written in such a way that new attributes won't cause the tests to start failing, but removing
  # data we were previously providing to users _will_ break the test suite.
  def assert_proper_object_serialization(ticket_data)
    # Fetch the ticket in question and prepare to compare it's attributes.
    ticket = Ticket.find(ticket_data["id"])

    assert_equal_or_nil ticket_data['status'], ticket.status
    assert_equal_or_nil ticket_data['comments'], ticket.comments
    # 🚅 super scaffolding will insert new fields above this line.

    assert_equal ticket_data["project_id"], ticket.project_id
  end

  test "index" do
    # Fetch and ensure nothing is seriously broken.
    get "/api/v1/projects/#{@project.id}/tickets", params: {access_token: access_token}
    assert_response :success

    # Make sure it's returning our resources.
    ticket_ids_returned = response.parsed_body.map { |ticket| ticket["id"] }
    assert_includes(ticket_ids_returned, @ticket.id)

    # But not returning other people's resources.
    assert_not_includes(ticket_ids_returned, @other_tickets[0].id)

    # And that the object structure is correct.
    assert_proper_object_serialization response.parsed_body.first
  end

  test "show" do
    # Fetch and ensure nothing is seriously broken.
    get "/api/v1/tickets/#{@ticket.id}", params: {access_token: access_token}
    assert_response :success

    # Ensure all the required data is returned properly.
    assert_proper_object_serialization response.parsed_body

    # Also ensure we can't do that same action as another user.
    get "/api/v1/tickets/#{@ticket.id}", params: {access_token: another_access_token}
    assert_response :not_found
  end

  test "create" do
    # Use the serializer to generate a payload, but strip some attributes out.
    params = {access_token: access_token}
    ticket_data = JSON.parse(build(:ticket, project: nil).to_api_json.to_json)
    ticket_data.except!("id", "project_id", "created_at", "updated_at")
    params[:ticket] = ticket_data

    post "/api/v1/projects/#{@project.id}/tickets", params: params
    assert_response :success

    # # Ensure all the required data is returned properly.
    assert_proper_object_serialization response.parsed_body

    # Also ensure we can't do that same action as another user.
    post "/api/v1/projects/#{@project.id}/tickets",
      params: params.merge({access_token: another_access_token})
    assert_response :not_found
  end

  test "update" do
    # Post an attribute update ensure nothing is seriously broken.
    put "/api/v1/tickets/#{@ticket.id}", params: {
      access_token: access_token,
      ticket: {
        comments: 'Alternative String Value',
        # 🚅 super scaffolding will also insert new fields above this line.
      }
    }

    assert_response :success

    # Ensure all the required data is returned properly.
    assert_proper_object_serialization response.parsed_body

    # But we have to manually assert the value was properly updated.
    @ticket.reload
    assert_equal @ticket.comments, 'Alternative String Value'
    # 🚅 super scaffolding will additionally insert new fields above this line.

    # Also ensure we can't do that same action as another user.
    put "/api/v1/tickets/#{@ticket.id}", params: {access_token: another_access_token}
    assert_response :not_found
  end

  test "destroy" do
    # Delete and ensure it actually went away.
    assert_difference("Ticket.count", -1) do
      delete "/api/v1/tickets/#{@ticket.id}", params: {access_token: access_token}
      assert_response :success
    end

    # Also ensure we can't do that same action as another user.
    delete "/api/v1/tickets/#{@another_ticket.id}", params: {access_token: another_access_token}
    assert_response :not_found
  end
end
