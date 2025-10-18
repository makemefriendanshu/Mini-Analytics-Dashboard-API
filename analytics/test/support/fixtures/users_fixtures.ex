defmodule Analytics.UsersFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Analytics.Users` context.
  """

  @doc """
  Generate a user.
  """
  def user_fixture(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> Enum.into(%{
        action_type: "some action_type",
        name: "some name"
      })
      |> Analytics.Users.create_user()

    user
  end
end
