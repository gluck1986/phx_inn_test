defmodule PhxWeb.PageView do
  use PhxWeb, :view

  def checks(_conn, checks: checks) do
    inspect(checks)
  end

  def title do
    "Awesome New Title!"
  end
end
