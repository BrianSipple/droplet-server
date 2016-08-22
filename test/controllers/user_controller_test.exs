defmodule Droplet.UserControllerTest do
  require Logger
  use Droplet.ConnCase

  alias Droplet.{TestHelper, Repo, User}

  @valid_attrs %{username: "bsipple4429", password: "testPassword123", password_confirmation: "testPassword123"}
  @invalid_attrs %{password: 2}

  setup %{conn: conn} do
    users =
      1..5
      |> Enum.map(fn(i) -> TestHelper.create_user(%{username: "testUser#{i}", first_name: "#{i}"}) end)
      |> Enum.map(fn(i) -> elem(i, 1) end)

    current_user = Enum.at(users, 0)

    # Get a token for our current_user to bypass validation
    {:ok, jwt, _ } = Guardian.encode_and_sign(current_user, :token)

    # TODO: There's probably a cleaner way of abstracting the above validation in the session
    # handler and then being able to do something like this:
    #
    # post build_conn(), "/token", session_params
    #
    # session_params = %{
    #   "grant_type": "password",
    #   "session": %{
    #     "identification": current_user.username,
    #     "password": current_user.password_hash
    #   }
    # }

    conn =
      conn
      |> put_req_header("accept", "application/vnd.api+json")
      |> put_req_header("content-type", "application/vnd.api+json")
      |> put_req_header("authorization", "Bearer #{jwt}")


    {:ok, conn: conn, users: users, current_user: current_user}
  end

  # TODO: Implement proper session handling to make this pass!
  # test "GET /users should display all users except the current user",
  #   %{conn: conn, users: users, current_user: current_user} do
  #
  #   conn = get conn, user_path(conn, :index)
  #   assert Enum.count(json_response(conn, 200)["data"]) == 4
  # end

  # test "shows chosen resource", %{conn: conn, users: users, current_user: current_user} do
  #   conn = get conn, user_path(conn, :show, current_user)
  #   assert json_response(conn, 200)["data"] == %{
  #
  #   }
  # end

  test "shows chosen resource",
    %{conn: conn, users: _, current_user: current_user} do

    conn = get conn, user_path(conn, :show, current_user)

    # TODO: There has to be a way to make this cleaner/more reusable 😀
    assert json_response(conn, 200)["data"] == %{
      "id" => to_string(current_user.id),
      "type" => "user",
      "relationships" => %{"notebooks" => %{}, "user-private-info" => %{}},
      "attributes" => %{
        "username" => current_user.username,
        "first-name" => current_user.first_name,
        "last-name" => current_user.last_name,
        "password-hash" => current_user.password_hash,
        "accessibility" => nil,
        "avatar-url" => nil,
        "bio" => nil,
        "language" => nil,
        "last-login" => nil,
        "location" => nil,
        "password" => nil,
        "password-confirmation" => nil,
        "twitter-username" => nil
      }
    }
  end

  test "renders page not found when id is nonexistent",
    %{conn: conn, users: _, current_user: _} do

    assert_error_sent 404, fn ->
      get conn, user_path(conn, :show, -1)
    end
  end

  test "creates and renders the resource when data is valid",
    %{conn: conn, users: _, current_user: _} do

    attrs = Poison.encode!(%{data: %{attributes: @valid_attrs}})

    conn = post conn, user_path(conn, :create), attrs

    users = Repo.all(User)
    user = List.last(users)

    assert response_content_type(conn, :json) =~ "charset=utf-8"
    assert json_response(conn, 201)["data"]["id"]
    assert user
  end

  test "does not create resource and renders errors when data is invalid",
    %{conn: conn, users: _, current_user: _} do

    attrs = Poison.encode!(%{data: %{attributes: @invalid_attrs}})

    conn = post conn, user_path(conn, :create), attrs

    assert response_content_type(conn, :json) =~ "charset=utf-8"
    assert json_response(conn, :unprocessable_entity)["errors"] != %{}
  end

  test "updates and renders chosen resource when data is valid",
    %{conn: conn, users: _, current_user: current_user} do

    new_attrs = Dict.merge(@valid_attrs, %{username: "HocusPocus"})
    encoded_attrs = Poison.encode!(%{data: %{attributes: new_attrs } })

    conn = put conn, user_path(conn, :update, current_user), encoded_attrs

    assert json_response(conn, 200)["data"]["id"]
    assert Repo.get_by(User, %{username: new_attrs.username})
  end

  test "does not update chosen resource and renders errors when data is invalid",
    %{conn: conn, users: _, current_user: current_user} do

    encoded_attrs = Poison.encode!%{data: %{attributes: @invalid_attrs}}
    conn = put conn, user_path(conn, :update, current_user), encoded_attrs

    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen resource",
    %{conn: conn, users: _, current_user: _} do

    {:ok, user} = TestHelper.create_user(%{username: "ImAUniqueUser"})

    conn = delete conn, user_path(conn, :delete, user)

    assert response(conn, 204)
    refute Repo.get(User, user.id)
  end

end
