defmodule Droplet.UserControllerTest do
  use Droplet.ConnCase

  # Protip: If the attributes we're expecting are coming directly from a model,
  # make our definitions here consistent the same
  # @valid_attrs in the model test
  @valid_attrs %{}
  @invalid_attrs %{}

  setup %{conn: conn} do
    conn =
      conn
      |> put_req_header("accept", "application/vnd.api+json")
      |> put_req_header("content-type", "application/vnd.api+json")

    {:ok, conn: conn}
  end

  # 📝 TODO: Test actions

end
