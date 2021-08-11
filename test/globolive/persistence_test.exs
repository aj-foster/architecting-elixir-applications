defmodule Globolive.PersistenceTest do
  use ExUnit.Case
  import Globolive.Factory

  alias Globolive.Core.{Attraction, Event, Visitor}
  alias Globolive.Persistence
  alias Globolive.Persistence.Checkin

  describe "create_checkin/2" do
    test "records a checkin" do
      {name, email} = visitor_fields()
      %Event{attractions: [attraction]} = event = event_with_attraction()
      visitor = Visitor.new(name, email, event)
      attraction_name = Attraction.id(attraction)

      assert {:ok, %Checkin{}} = Persistence.create_checkin(visitor, attraction_name)
      assert [%Checkin{}] = Persistence.list_checkins(visitor)
    end
  end
end
