defmodule Globolive.Web.CheckinController do
  @moduledoc """
  Provides controller action for checking in visitors at attractions.
  """
  use Globolive.Web, :controller

  alias Plug.Conn
  alias Globolive.Core.Visitor
  alias Globolive.Boundary.VisitorSession

  @spec create(Conn.t(), Conn.params()) :: Conn.t()
  def create(conn, %{
        "email" => visitor_email,
        "event" => event_name,
        "attraction" => attraction_name
      }) do
    case VisitorSession.mark_checkin({visitor_email, event_name}, attraction_name) do
      %Visitor{} ->
        Conn.send_resp(conn, 204, "")

      {:error, _reason} ->
        Conn.send_resp(conn, 500, "Error while processing checkin")
    end
  end

  def create(conn, _params) do
    Conn.send_resp(conn, 400, "Please provide email, event, and attraction")
  end
end
