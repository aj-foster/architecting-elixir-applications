defmodule Globolive.Web.CheckinControllerTest do
  use ExUnit.Case
  import Phoenix.ConnTest
  import Globolive.Factory

  @endpoint Globolive.Web.Endpoint

  alias Globolive.Web.Router.Helpers, as: Routes
  alias Globolive.Core.{Attraction, Event}
  alias Globolive.Boundary.VisitorSupervisor

  describe "create/2" do
    test "checks in a visitor" do
      {name, email} = visitor_fields()
      %Event{attractions: [attraction]} = event = event_with_attraction()
      VisitorSupervisor.create_visitor({name, email, event})

      event_name = Event.id(event)
      attraction_name = Attraction.id(attraction)

      conn = build_conn()

      conn =
        post(conn, Routes.checkin_path(conn, :create), %{
          "email" => email,
          "event" => event_name,
          "attraction" => attraction_name
        })

      assert response(conn, 204)
    end
  end
end
