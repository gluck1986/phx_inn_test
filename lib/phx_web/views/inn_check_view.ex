defmodule PhxWeb.InnCheckView do
  use PhxWeb, :view

  def can_ip?(conn) do
    user = Guardian.Plug.current_resource(conn)
    :ok == Bodyguard.permit(Phx.Policy, :ip_operation, user, nil)
  end
end
