defmodule Phx.GuardianSerializer do
  @moduledoc false

  @behaviour Guardian.Serializer

  alias Phx.Repo
  alias Phx.Users.User
  alias Phx.Users

  def for_token(user = %User{}), do: {:ok, "User:#{user.id}"}
  def for_token(_), do: {:error, "Неизвестный ресурс"}

  def from_token("User:" <> id), do: {:ok, Users.get_user!(id)}
  def from_token(_), do: {:error, "Неизвестный ресурс"}
end
