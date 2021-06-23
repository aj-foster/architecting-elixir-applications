defmodule Globolive.Core.VisitorTest do
  use ExUnit.Case
  import Globolive.Factory

  alias Globolive.Core.{Event, Visitor}

  describe "new/3" do
    test "creates a new visitor" do
      {name, email} = visitor_fields()
      event = Event.new(event_fields())

      assert %Visitor{name: ^name, email: ^email, event: %Event{}} =
               Visitor.new(name, email, event)
    end
  end
end
