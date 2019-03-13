defmodule PhxWeb.LayoutView do
  use PhxWeb, :view

  def current_user(conn) do
    Guardian.Plug.current_resource(conn)
  end
end
