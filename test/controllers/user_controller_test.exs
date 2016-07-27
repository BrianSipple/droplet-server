defmodule Droplet.UserControllerTest do
  use Droplet.ConnCase
  alias Droplet.User

  # Protip: make these consistent with the @valid_attrs in user_model_test.ex
  @valid_attrs %{
    first_name: "Brian",
    last_name: "Sipple",
    username: "bsipple",
    password: "linkedIn123",
    password_confirmation: "linkedIn123"
  }
  @invalid_attrs %{}
end
