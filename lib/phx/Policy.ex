defmodule Phx.Policy do
  @behaviour Bodyguard.Policy

  def authorize(:ip_operation, user, _) do
    user.admin
  end
end
