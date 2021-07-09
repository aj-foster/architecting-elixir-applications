defmodule Globolive.Core.AttractionTest do
  use ExUnit.Case
  import Globolive.Factory

  alias Globolive.Core.{Attraction, Schedulable}

  describe "new/1" do
    test "creates a new attraction" do
      attributes = attraction_fields()
      assert %Attraction{} = Attraction.new(attributes)
    end
  end

  describe "Schedulable.duration/1" do
    test "returns duration of the attraction" do
      now = DateTime.utc_now()
      attraction = Attraction.new(attraction_fields(start: now, finish: DateTime.add(now, 3333)))
      assert Schedulable.duration(attraction) == 3333
    end
  end
end
